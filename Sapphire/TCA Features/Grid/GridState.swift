//
//  UserData.swift
//  Sapphire
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI
import ComposableArchitecture
import DynamicColor

struct GridState: Equatable {
  var macOSApplications: IdentifiedArrayOf<MacOSApplicationState> = []
  var alert: AlertState<GridAction>?
  var inFlight = false
  @BindableState var selectedColor = Color.white
}

enum GridAction: BindableAction, Equatable {
  // binding
  case binding(BindingAction<GridState>)
  
  // children
  case macOSApplication(id: MacOSApplicationState.ID, action: MacOSApplicationAction)
  
  // get icons
  case getSystemIcons          ; case didGetSystemIcons(Result<IdentifiedArrayOf<MacOSApplicationState>, AppError>)
  
  // save/load gridstate
  case saveGridState           ; case didSaveGridState(Result<IdentifiedArrayOf<MacOSApplicationState>, AppError>)
  case loadGridState           ; case didLoadGridState(Result<Bool, AppError>)
  
  // selection
  case selectAllButtonTapped   ; case selectModifiedButtonTapped ; case selectAll ; case deselectAll
  
  // set/reset icons
  case setSystemApplications   ; case didSetSystemApplications(Result<Bool, AppError>)
  case resetSystemApplications ; case didResetSystemApplications(Result<Bool, AppError>)
  
  // create/dismiss alerts
  case createSetIconsAlert     ; case didDismissSetIconsAlert
  case createResetIconsAlert   ; case didDismissResetIconsAlert
}

struct GridEnvironment {
  let localDataClient: LocalDataClient<IdentifiedArrayOf<MacOSApplicationState>> =
    .live(
      url: FileManager
        .applicationSupportDirectory(named: "KSWIFTSapphire")
        .appendingPathComponent("GridState.json")
    )
  let iconsurClient: IconsurClient = .live
  let scheduler: AnySchedulerOf<DispatchQueue> = .main
}


let gridReducer = Reducer<GridState, GridAction, GridEnvironment>.combine(
  macOSApplicationReducer.forEach(
    state: \.macOSApplications,
    action: /GridAction.macOSApplication(id:action:),
    environment: { _ in () }
  ),
  Reducer { state, action, environment in
    struct GridRequestId: Hashable {}
    
    switch action {
      
    case .binding:
      return .none
      
    case .getSystemIcons:
      return environment.iconsurClient.getIcons()
        .mapError(AppError.init)
        .receive(on: environment.scheduler)
        .catchToEffect()
        .map(GridAction.didGetSystemIcons)
      
    case let .didGetSystemIcons(.success(icons)):
      state.macOSApplications = icons
      return Effect(value: .loadGridState)
      
    case let .didGetSystemIcons(.failure(error)):
      print(error.localizedDescription)
      return .none
      
    case .saveGridState:
      return environment.localDataClient.save(state.macOSApplications)
        .mapError(AppError.init)
        .receive(on: environment.scheduler)
        .catchToEffect()
        .map(GridAction.didLoadGridState)
      
    case .loadGridState:
      return environment.localDataClient.load()
        .mapError(AppError.init)
        .receive(on: environment.scheduler)
        .catchToEffect()
        .map(GridAction.didSaveGridState)
      
    case let .didSaveGridState(.success(items)):
      state.macOSApplications = items
      return .none
      
    case let .didSaveGridState(.failure(error)):
      print(error.localizedDescription)
      return .none
      
    case .didLoadGridState:
      return .none
      
      // MARK: - macOSApplication
    case let .macOSApplication(id, action):
      switch action {
        
      case .toggleSelected:
        state.macOSApplications[id: id]!.selected.toggle()
        return .none
        
      case .modifyIconButtonTapped:
        return Effect(value: .createSetIconsAlert)
        
      default:
        break
      }
      return Effect(value: .saveGridState)
      
      // MARK: - Set
    case .setSystemApplications:
      state.inFlight = true
      return environment.iconsurClient.setIcons(state.macOSApplications.filter(\.selected), state.selectedColor)
      
    case .didSetSystemApplications(.success):
      state.macOSApplications = state.macOSApplications.reduce(set: \.modified, to: true, where: \.selected).reduce(set: \.colorHex, to: state.selectedColor.hex, where: \.selected)
      state.inFlight = false
      return Effect(value: .deselectAll)
      
    case let .didSetSystemApplications(.failure(error)):
      state.inFlight = false
      return Effect(value: .deselectAll)
      
    case .createSetIconsAlert:
      state.alert = AlertState(
        title: TextState("Password Required"),
        message: TextState("Requesting permission to modify system icons."),
        primaryButton: .destructive(TextState("Continue"), action: .send(.setSystemApplications)),
        secondaryButton: .cancel(TextState("Cancel"))
      )
      return .none
      
    case .didDismissSetIconsAlert:
      state.alert = nil
      return .none
      
      // MARK: - Reset
    case .resetSystemApplications:
      state.inFlight = true
      return environment.iconsurClient
        .resetIcons(state.macOSApplications.filter(\.selected))
      
    case .didResetSystemApplications(.success):
      state.macOSApplications = state.macOSApplications.reduce(set: \.modified, to: false, where: \.selected)
      state.inFlight = false
      return Effect(value: .deselectAll)
      
    case let .didResetSystemApplications(.failure(error)):
      state.inFlight = false
      return Effect(value: .deselectAll)
      
    case .createResetIconsAlert:
      state.alert = .init(
        title: TextState("Password Required"),
        message: TextState("Requesting permission to modify system icons."),
        primaryButton: .destructive(TextState("Continue"), action: .send(.resetSystemApplications)),
        secondaryButton: .cancel(TextState("Cancel"))
      )
      return .none
      
    case .didDismissResetIconsAlert:
      state.alert = nil
      return .none
      
      // MARK: - Select
    case .selectAllButtonTapped:
      state.macOSApplications = state.macOSApplications.reduce(set: \.selected, to: !state.macOSApplications.allSatisfy(\.selected))
      return .none
      
    case .selectAll:
      state.macOSApplications = state.macOSApplications.reduce(set: \.selected, to: true)
      return .none
      
    case .deselectAll:
      state.macOSApplications = state.macOSApplications.reduce(set: \.selected, to: false)
      return Effect(value: .saveGridState)
      
    case .selectModifiedButtonTapped:
      switch state.macOSApplications.filter(\.modified).allSatisfy(\.selected) && state.macOSApplications.filter(\.selected).allSatisfy(\.modified) {
        
      case true:
        return Effect(value: .deselectAll)
        
      case false:
        state.macOSApplications = state.macOSApplications.reduce(set: \.selected, to: \.modified)
      }
      return .none

    }
  }
    .binding()
    .debug()
)


extension Store where State == GridState, Action == GridAction {
  static let `default` = Store(
    initialState: .init(),
    reducer: gridReducer,
    environment: .init()
  )
}




