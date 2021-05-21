//
//  UserData.swift
//  Sapphire
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI
import ComposableArchitecture

// Generate Icon:
// sudo /usr/local/bin/iconsur set /Applications/Scroll\ Reverser.app -l -s 0.8 -o ~/Desktop/"Scroll Reverser".png -c ffffff

// Set Icon:
// sudo /usr/local/bin/iconsur set /Applications/Scroll\ Reverser.app -l ~/Desktop/"Scroll Reverser".png



struct Grid {
    struct State: Equatable, Codable {
        var macOSApplications : [MacOSApplication.State] = .allCases
    }
    
    enum Action: Equatable {
        case macOSApplication(index: Int, action: MacOSApplication.Action)
        case modifyLocalIcons
        case selectAllButtonTapped
        case updateMacOSApplicationsState
        case updateGridSelections(Int)
    }
    
    struct Environment {
        let iconsurPath = "/usr/local/bin/iconsur"
        
        /// Returns an Applescript-formatted String for updating application icons.
        func getUpdateLocalApplicationsCommand(_ applications: [MacOSApplication.State]) -> String {
            let command = applications
                .filter(\.selected)
                .reduce(into: []) { array, application in
                    array.append(
                        application.customized
                            ? "\(iconsurPath) unset \\\"\(application.url.path)\\\"; "
                            : "\(iconsurPath) set \\\"\(application.url.path)\\\" -l -s 0.8 -o ~/Desktop/\(application.name).png -c \(application.color); \(iconsurPath) set \\\"\(application.url.path)\\\" -l ~/Desktop/\(application.name).png; "
                    )
                    print("/usr/local/bin/iconsur set \\\"\(application.url.path)\\\" -l -s 0.8; ")
                }
                .joined()
                .appending("/usr/local/bin/iconsur cache")
            
            return "do shell script \"\(command)\" with administrator privileges"
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
                
            case let .updateGridSelections(index):
                state.macOSApplications[index].selected.toggle()
                return .none

            case .modifyLocalIcons:
                let result = AppleScript.execute(environment.getUpdateLocalApplicationsCommand(state.macOSApplications))
                //let outputImage = AppleScript.execute(environment.getCreateIconCommand(state.macOSApplications))

                switch result {
                
                // I want to wait for the process to complete.
                case .success:
                    return Effect(value: .updateMacOSApplicationsState)
                        //.delay(for: 10.0, scheduler: DispatchQueue.main)
                        //.eraseToEffect()

                case let .failure(error):
                    print(error.localizedDescription)
                    return .none
                }
                                
            case .updateMacOSApplicationsState:
                Array(zip(state.macOSApplications.indices, state.macOSApplications))
                    .forEach { index, application in
                        if state.macOSApplications[index].selected {
                            state.macOSApplications[index].customized.toggle()
                        }
                    }
                return .none
                                                
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

extension Grid {
    static let defaultStore = Store(
        initialState: .init(),
        reducer: reducer,
        environment: .init()
    )
}
