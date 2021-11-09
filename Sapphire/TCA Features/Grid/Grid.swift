//
//  UserData.swift
//  Sapphire
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI
import Combine
import ComposableArchitecture
import DynamicColor
import CombineSchedulers
import IdentifiedCollections

struct GridState: Equatable {
  var macOSApplications: IdentifiedArrayOf<MacOSApplicationState> = []
  var alert: AlertState<GridAction>?
  var inFlight = false
  var selectedColor = Color.white
}

enum GridAction: Equatable {
  
  // Root
  case macOSApplication(id: MacOSApplicationState.ID, action: MacOSApplicationAction)
  
  // macOSApplication
  case onAppear
  case getSystemIcons
  case didGetSystemIcons(Result<IdentifiedArrayOf<MacOSApplicationState>, AppError>)

  // Grid
  case saveGridState
  case loadGridState
  case didSaveGridState(Result<IdentifiedArrayOf<MacOSApplicationState>, AppError>)
  case didLoadGridState(Result<Bool, AppError>)
  
  case selectAllButtonTapped
  case selectModifiedButtonTapped
  case selectAll
  case deselectAll
  case updateSelectedColor(Color)
  
  // Set Icons
  case setSystemApplications
  case setSystemApplicationsResult(Result<Bool, NSUserAppleScriptTaskError>)
  case createSetIconsAlert
  case dismissSetIconsAlert
  
  // Reset Icons
  case resetSystemApplications
  case resetSystemApplicationsResult(Result<Bool, NSUserAppleScriptTaskError>)
  case createResetIconsAlert
  case dismissResetIconsAlert
}

struct GridEnvironment {
  let localDataClient: LocalDataClient<IdentifiedArrayOf<MacOSApplicationState>>
  let iconsurClient: IconsurClient
  let scheduler: AnySchedulerOf<DispatchQueue>
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
      
      // MARK: - Root
    case .onAppear:
      return Effect(value: .getSystemIcons)
      
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
      return environment.iconsurClient.setIcons(state.macOSApplications, state.selectedColor)
      
    case .setSystemApplicationsResult(.success):
      state.macOSApplications = state.macOSApplications.reduce(set: \.modified, to: true, where: \.selected).reduce(set: \.colorHex, to: state.selectedColor.hex, where: \.selected)
      state.inFlight = false
      return Effect(value: .deselectAll)
      
    case let .setSystemApplicationsResult(.failure(error)):
      state.inFlight = false
      return Effect(value: .deselectAll)
      
//    case .cancelSetSystemApplications:
//      state.inFlight = false
//      return .cancel(id: GridRequestId())
      
    case .createSetIconsAlert:
      state.alert = AlertState(
        title: TextState("Password Required"),
        message: TextState("Requesting permission to modify system icons."),
        primaryButton: .destructive(TextState("Continue"), action: .send(.setSystemApplications)),
        secondaryButton: .cancel(TextState("Cancel"))
      )
      return .none
      
    case .dismissSetIconsAlert:
      state.alert = nil
      return .none
      
      // MARK: - Reset
    case .resetSystemApplications:
      state.inFlight = true
      return environment.iconsurClient.resetIcons(state.macOSApplications)
      
    case .resetSystemApplicationsResult(.success):
      state.macOSApplications = state.macOSApplications.reduce(set: \.modified, to: false, where: \.selected)
      state.inFlight = false
      return Effect(value: .deselectAll)
      
    case let .resetSystemApplicationsResult(.failure(error)):
      state.inFlight = false
      return Effect(value: .deselectAll)
      
//    case .cancelResetSystemApplications:
//      state.inFlight = false
//      return .cancel(id: GridRequestId())
      
    case .createResetIconsAlert:
      state.alert = .init(
        title: TextState("Password Required"),
        message: TextState("Requesting permission to modify system icons."),
        primaryButton: .destructive(TextState("Continue"), action: .send(.resetSystemApplications)),
        secondaryButton: .cancel(TextState("Cancel"))
      )
      return .none
      
    case .dismissResetIconsAlert:
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
      
      // MARK: - Color
    case let .updateSelectedColor(color):
      state.selectedColor = color
      
      return .none
    }
  }
    .debug()
)

extension GridState {
  static let defaultStore = Store(
    initialState: .init(),
    reducer: gridReducer,
    environment: .init(
      localDataClient: .live(url: URL.ApplicationSupport.appendingPathComponent("GridState.json")),
      iconsurClient: .live,
      scheduler: .main
    )
  )
}


