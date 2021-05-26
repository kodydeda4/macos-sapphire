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
        var onboarding = false
        var sheet: Bool {
            inFlight || onboarding
        }
    }
    
    enum Action: Equatable {
        case macOSApplication(index: Int, action: MacOSApplication.Action)
        
        // Root
        case onAppear
        case save
        case load
        case toggleOnboarding
        case toggleSheetView

        // Grid
        case selectAll
        case deselectAll
        case selectAllButtonTapped
        case selectModifiedButtonTapped
        case modifySystemApplications
        case modifySystemApplicationsResult(Result<Bool, AppleScriptError>)

        
        // App
        case createAlert
        case dismissAlert
        case cancelButtonTapped
        
    }
    
    struct Environment {
        let stateURL = URL.ApplicationSupport
            .appendingPathComponent("GridState.json")
        
        let iconsurURL = URL.ApplicationScripts
            .appendingPathComponent("iconsur2")

        /// Returns AppleScript command for modifying System Application Icons.
        func modifyIconsCommand(_ applications: [MacOSApplication.State]) -> String {
            let updateIcons = applications
                .filter(\.selected)
                .map { application in
                    let iconsur = iconsurURL.appleScriptPath
                    let app = application.url.appleScriptPath
                    let icon = application.customizedURL.appleScriptPath
                    let color = application.color
                    
                    let reset  = "\(iconsur) unset \(app); "
                    let create = "\(iconsur) set \(app) -l -s 0.8 -o \(icon) -c \(color); "
                    let set    = "\(iconsur) set \(app) -l \(icon); "
                    
                    return application.modified
                        ? reset
                        : [create, set].joined()
                }
                .joined()
                .appending("\(iconsurURL.appleScriptPath) cache")
            
            return "do shell script \"\(updateIcons)\" with administrator privileges"
        }
        
        /// Executes modifyIconsCommand as Effect
        func modifyIcons(command: String) -> Effect<Action, Never> {
            NSUserAppleScriptTask()
                .execute(command)
                .map(Action.modifySystemApplicationsResult)
                .receive(on: DispatchQueue.main)
                .eraseToEffect()
                .cancellable(id: GridRequestId())
        }
    }
}

struct GridRequestId: Hashable {}


extension Grid {
    static let reducer = Reducer<State, Action, Environment>.combine(
        MacOSApplication.reducer.forEach(
            state: \.macOSApplications,
            action: /Action.macOSApplication(index:action:),
            environment: { _ in () }
        ),
        Reducer { state, action, environment in

            switch action {
            
            case .toggleSheetView:
                return .none

            case .onAppear:
//                if state.onboarding {
//                    state.alert = .init(
//                        title: "Welcome to Sapphire",
//                        message: "Kody Deda",
//                        dismissButton: .cancel("Continue", send: .toggleOnboarding)
//                    )
//                }
                return Effect(value: .load)
            
            case .load:
                switch JSONDecoder().decodeState(
                    ofType: [MacOSApplication.State].self,
                    from: environment.stateURL
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
                let _ = JSONEncoder().writeState(
                    state.macOSApplications,
                    to: environment.stateURL
                )
                return .none

            case .modifySystemApplications:
                state.inFlight = true
                return environment.modifyIcons(command: environment.modifyIconsCommand(state.macOSApplications))
                
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


