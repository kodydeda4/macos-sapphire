//
//  UserData.swift
//  Sapphire
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI
import Combine
import ComposableArchitecture

struct Grid {
    struct State: Equatable {
        var macOSApplications: [MacOSApplication.State] = .allCases
        var alert: AlertState<Grid.Action>?
        var inFlight = false
        var applyingChanges = false
        var onboarding = true
        var sheet: Bool {
            inFlight || onboarding
        }
    }
    
    enum Action: Equatable {
        case macOSApplication(index: Int, action: MacOSApplication.Action)
        case selectAllButtonTapped
        case cancelButtonTapped
        case selectModifiedButtonTapped
        case selectAll
        case deselectAll
        case save
        case disableInFlight
        case createAlert
        case dismissAlert
        case toggleSheetView
        
        case onAppear
        case modifySystemApplications
        case modifySystemApplicationsResult(Result<Bool, AppleScriptError>)
        case toggleOnboarding
    }
    
    struct Environment {
        let dataURL = URL(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent("SapphireState.json")

        let iconsur = "/usr/local/bin/iconsur"
        
        /// Modify System Application Icons.
        func modifySystemApplicationIcons(_ applications: [MacOSApplication.State]) -> Effect<Action, Never> {
            let updateIcons = applications
                .map { application in
                    
                    let reset  = "\(iconsur) unset \\\"\(application.url.path)\\\"; "
                    let create = "\(iconsur) set \\\"\(application.url.path)\\\" -l -s 0.8 -o \(application.customizedURL.path) -c \(application.color); "
                    let set    = "\(iconsur) set \\\"\(application.url.path)\\\" -l \(application.customizedURL.path); "
                    
                    return application.modified
                        ? reset
                        : [create, set].joined()
                }
                .joined()
                .appending("\(iconsur) cache")
            
            
            return NSUserAppleScriptTask()
                .execute(command: "do shell script \"\(updateIcons)\" with administrator privileges")
                .map(Action.modifySystemApplicationsResult)
                .receive(on: DispatchQueue.main)
                .eraseToEffect()
        }
    }
}

extension Grid {
    static let reducer = Reducer<State, Action, Environment>.combine(
        MacOSApplication.reducer.forEach(
            state: \.macOSApplications,
            action: /Action.macOSApplication(index:action:),
            environment: { _ in () }
        ),
        Reducer { state, action, environment in
            struct GridRequestId: Hashable {}

            switch action {
            
            case .toggleSheetView:
                return .none

            case .onAppear:
                switch JSONDecoder().decodeState(
                    ofType: [MacOSApplication.State].self,
                    from: environment.dataURL
                ) {
                case let .success(decodedState):
                    state.macOSApplications = decodedState
                case let .failure(error):
                    print(error.localizedDescription)
                }
                return .none
                
            case .createAlert:
                state.alert = .init(
                    title: "Password Required",
                    message: "Requesting permission to modify system icons.",
                    primaryButton: .destructive("Continue", send: .modifySystemApplications),
                    secondaryButton: .cancel()
                )
                return .none

            case .dismissAlert:
                state.alert = nil
                return .none

            
            case let .macOSApplication(index, action):
                switch action {
                
                case .toggleSelected:
                    state.macOSApplications[index].selected.toggle()
                    return .none
                    
                case .modifyIconButtonTapped:
                    return Effect(value: .createAlert)
                    
                default:
                    break
                }
                return Effect(value: .save)
                
            case .save:
                let _ = JSONEncoder().writeState(state.macOSApplications, to: environment.dataURL)
                return .none

                
            case .modifySystemApplications:
                state.inFlight = true
                state.applyingChanges = true
                return environment.modifySystemApplicationIcons(state.macOSApplications.filter(\.selected))
                
            case .modifySystemApplicationsResult(.success):
                state.macOSApplications = state.macOSApplications.reduce(into: []) { array, element in
                    var application = element
                    
                    if application.selected {
                        
                        application.icon = application.modified
                            ? Bundle.icon(from: application.url)
                            : application.customizedURL
                        
                        application.modified.toggle()
                    }
                    array.append(application)
                }
                
                state.applyingChanges = false
                return Effect(value: .disableInFlight)
                
            case .disableInFlight:
                state.inFlight = false
                return Effect(value: .save)
                    .delay(for: 2.0, scheduler: DispatchQueue.main)
                    .eraseToEffect()

                
            case let .modifySystemApplicationsResult(.failure(error)):
                state.inFlight = false
                return Effect(value: .deselectAll)
                
            case .selectAllButtonTapped:
                let allSelected = state.macOSApplications.allSatisfy(\.selected)
                
                state.macOSApplications.indices.forEach {
                    state.macOSApplications[$0].selected = !allSelected
                }
                return .none
                
            case .selectAll:
                state.macOSApplications.indices.forEach {
                    state.macOSApplications[$0].selected = true
                }
                return .none
                
            case .deselectAll:
                state.macOSApplications.indices.forEach {
                    state.macOSApplications[$0].selected = false
                }
                return .none
                
            case .selectModifiedButtonTapped:
                switch state.macOSApplications
                    .filter(\.modified)
                    .allSatisfy(\.selected)
                    
                    &&
                    
                    state.macOSApplications
                    .filter(\.selected)
                    .allSatisfy(\.modified)
                {
                case true:
                    return Effect(value: .deselectAll)
                    
                case false:
                    state.macOSApplications.indices.forEach {
                        state.macOSApplications[$0].selected = state.macOSApplications[$0].modified
                    }
                }
                return .none
                
            case .cancelButtonTapped:
                state.inFlight = false
                return .cancel(id: GridRequestId())
                
            case .toggleOnboarding:
                state.onboarding.toggle()
                return .none

            }
        }
    )
}

extension Grid {
    static let defaultStore = Store(
        initialState: .init(),
        reducer: reducer,
        environment: .init()
    )
}
