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
        let iconsur = "/usr/local/bin/iconsur"
        let output = "~/Desktop/"
        
        /// Remove customized icon from MacOSApplication.
        func unsetIcon(for application: MacOSApplication.State) -> String {
            "\(iconsur) unset \\\"\(application.url.path)\\\"; "
        }
        
        /// Create customized icon for MacOSApplication.
        func createIcon(for application: MacOSApplication.State) -> String {
            "\(iconsur) set \\\"\(application.url.path)\\\" -l -s 0.8 -o \(output)\(application.name).png -c \(application.color); "
        }
        
        /// Set customized icon for MacOSApplication.
        func setIcon(for application: MacOSApplication.State) -> String {
            "\(iconsur) set \\\"\(application.url.path)\\\" -l \(output)\(application.name).png; "
        }
        
        /// Sets / Unsets [MacOSApplication] and outputs [Image] to disk.
        func updateLocalApplications(_ applications: [MacOSApplication.State]) -> Result<Bool, Error> {
            let command = applications
                .filter(\.selected)
                .reduce(into: []) { array, application in
                    array.append(
                        application.customized
                            ? unsetIcon(for: application)
                            : [createIcon(for: application), setIcon(for: application)].joined()
                    )
                }
                .joined()
                //.appending("/usr/local/bin/iconsur cache")
            
            return AppleScript.execute("do shell script \"\(command)\" with administrator privileges")
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
                switch environment.updateLocalApplications(state.macOSApplications) {
                
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
                        if application.selected {
                            state.macOSApplications[index].customized.toggle()
                            
                            if state.macOSApplications[index].customized {
                                state.macOSApplications[index].icon = URL(string: "\(environment.output)\(state.macOSApplications[index].name)")!
                            } else {
                                state.macOSApplications[index].icon = Bundle.icon(from: state.macOSApplications[index].icon)
                            }
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
