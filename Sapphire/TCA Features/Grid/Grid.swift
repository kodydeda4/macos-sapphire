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
    }
    
    enum Action: Equatable {
        case macOSApplication(index: Int, action: MacOSApplication.Action)
        
        // Root
        case onAppear
        case save
        case load

        // Grid
        case selectAll
        case deselectAll
        case selectAllButtonTapped
        case selectModifiedButtonTapped
        
        // Modify System
        case modifySystemApplications
        case modifySystemApplicationsResult(Result<Bool, AppleScriptError>)
        case cancelModifySystemApplications
        
        // Alerts
        case createPasswordRequiredAlert
        case dismissPasswordRequiredAlert
    }
    
    struct Environment {
        let stateURL = URL.ApplicationSupport
            .appendingPathComponent("GridState.json")
        
        let iconsurURL = URL.ApplicationScripts
            .appendingPathComponent("iconsur2")
        
        /// Executes modifyIconsCommand as Effect
        func modifyIcons(applications: [MacOSApplication.State]) -> Effect<Action, Never> {
            let updateIcons = applications
                .filter(\.selected)
                .map { application in
                    let iconsur = iconsurURL.appleScriptPath
                    let app = application.bundleURL.appleScriptPath
                    let icon = application.modifiedIconURL.appleScriptPath
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
            
            let command = "do shell script \"\(updateIcons)\" with administrator privileges"

            return NSUserAppleScriptTask()
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

                
            case .createPasswordRequiredAlert:
                state.alert = .init(
                    title: "Password Required",
                    message: "Requesting permission to modify system icons.",
                    primaryButton: .destructive("Continue", send: .modifySystemApplications),
                    secondaryButton: .cancel()
                )
                return .none

            case .dismissPasswordRequiredAlert:
                state.alert = nil
                return .none
            
            case let .macOSApplication(index, action):
                switch action {
                
                case .toggleSelected:
                    state.macOSApplications[index].selected.toggle()
                    return .none
                    
                case .modifyIconButtonTapped:
                    return Effect(value: .createPasswordRequiredAlert)
                    
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
                return environment.modifyIcons(applications: state.macOSApplications)
                
            case .modifySystemApplicationsResult(.success):
                state.macOSApplications = state.macOSApplications
                    .reduce(set: \.iconURL, to: { $0.modified ? $0.defaultIconURL : $0.modifiedIconURL }, where: \.selected)
                    .reduce(set: \.modified, to: \.modified.inverse, where: \.selected)
                
                state.inFlight = false
                
                return Effect(value: .save)
                
            case let .modifySystemApplicationsResult(.failure(error)):
                state.inFlight = false
                return Effect(value: .deselectAll)
                
            case .selectAllButtonTapped:
                state.macOSApplications =
                    state.macOSApplications.reduce(
                        set: \.selected,
                        to: !state.macOSApplications.allSatisfy(\.selected)
                    )
                return .none
                
            case .selectAll:
                state.macOSApplications =
                    state.macOSApplications.reduce(
                        set: \.selected,
                        to: true
                    )
                return .none
                
            case .deselectAll:
                state.macOSApplications =
                    state.macOSApplications.reduce(
                        set: \.selected,
                        to: false
                    )
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
                    state.macOSApplications =
                        state.macOSApplications.reduce(
                            set: \.selected,
                            to: \.modified
                        )
                }
                return .none
                
            case .cancelModifySystemApplications:
                state.inFlight = false
                return .cancel(id: GridRequestId())
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


