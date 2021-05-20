//
//  Root.swift
//  Sapphire
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI
import ComposableArchitecture

struct Root {
    struct State: Equatable, Codable {
        var macOSApplications : [MacOSApplication.State] = .allCases
    }
    
    enum Action: Equatable {
        case macOSApplication(index: Int, action: MacOSApplication.Action)
        case save
        case reset
        case onAppear
        case modifyLocalIcons
        case selectAllButtonTapped
        case updateRootState
        case updateGridSelections(Int)
    }
    
    struct Environment {
        let dataURL = URL(fileURLWithPath: "SapphireState.json", relativeTo: URL(fileURLWithPath: NSHomeDirectory()))
        
        /// Returns an Applescript-formatted String for updating application icons.
        func getUpdateLocalApplicationsCommand(_ applications: [MacOSApplication.State]) -> String {
            let command = applications
                .filter(\.selected)
                .reduce(into: []) { array, application in
                    array.append(
                        application.customized
                            ? "/usr/local/bin/iconsur unset \\\"\(application.url.path)\\\"; "
                            : "/usr/local/bin/iconsur set \\\"\(application.url.path)\\\" -l -s 0.8; "
                    )
                }
                .joined()
                .appending("/usr/local/bin/iconsur cache")
            
            return "do shell script \"\(command)\" with administrator privileges"
        }
    }
}

extension Root {
    static let reducer = Reducer<State, Action, Environment>.combine(
        MacOSApplication.reducer.forEach(
            state: \.macOSApplications,
            action: /Action.macOSApplication(index:action:),
            environment: { _ in () }
        ),
        Reducer { state, action, environment in
            switch action {
            
            case let .macOSApplication(index, action):
                switch action {
                
                case .toggleSelected:
                    return Effect(value: .updateGridSelections(index))
                
                case .modifyIconButtonTapped:
                    return Effect(value: .modifyLocalIcons)
                
                default:
                    break
                }
                return .none
            
            case .save:
                let _ = JSONEncoder().writeState(state, to: environment.dataURL)
                return .none
                
            case .reset:
                Array(zip(state.macOSApplications.indices, state.macOSApplications))
                    .forEach { index, application in
                        if state.macOSApplications[index].selected {
                            state.macOSApplications[index].customized = false
                        }
                    }
                return Effect(value: .modifyLocalIcons)

                
            case .onAppear:
                switch JSONDecoder().decodeState(ofType: Root.State.self, from: environment.dataURL) {
                case let .success(decodedState):
                    state = decodedState
                case let .failure(error):
                    print(error.localizedDescription)
                }
                return .none
                
            case let .updateGridSelections(index):
                state.macOSApplications[index].selected.toggle()
                print("selections: \(state.macOSApplications.filter(\.selected).map(\.name))")
                return Effect(value: .save)

            case .modifyLocalIcons:
                let result = AppleScript.execute(environment.getUpdateLocalApplicationsCommand(state.macOSApplications))
                switch result {
                
                // I want to wait for the process to complete.
                case .success:
                    return Effect(value: .updateRootState)
                        //.delay(for: 10.0, scheduler: DispatchQueue.main)
                        //.eraseToEffect()

                case let .failure(error):
                    print(error.localizedDescription)
                    return .none
                }
                                
            case .updateRootState:
                Array(zip(state.macOSApplications.indices, state.macOSApplications))
                    .forEach { index, application in
                        if state.macOSApplications[index].selected {
                            state.macOSApplications[index].customized.toggle()
                        }
                    }
                return Effect(value: .save)
                                                
            case .selectAllButtonTapped:
                let bool = state.macOSApplications.filter(\.selected).isEmpty
                
                Array(zip(state.macOSApplications.indices, state.macOSApplications))
                    .forEach { index, application in
                        state.macOSApplications[index].selected = bool
                    }
                return .none
            }
        }
    )
}

extension Root {
    static let defaultStore = Store(
        initialState: .init(),
        reducer: reducer,
        environment: .init()
    )
}
