//
//  UserData.swift
//  Sapphire
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI
import ComposableArchitecture

struct Grid {
    struct State: Equatable, Codable {
        var macOSApplications : [MacOSApplication.State] = .allCases
    }
    
    enum Action: Equatable {
        case macOSApplication(index: Int, action: MacOSApplication.Action)
        case modifyLocalIcons
        case selectAllButtonTapped
        case selectModifiedButtonTapped
        case updateMacOSApplicationsState
        case updateGridSelections(Int)
    }
    
    struct Environment {
        let iconsur = "/usr/local/bin/iconsur"
        let output = "~/Desktop/"
        
        /// Removes a customized icon from a MacOSApplication.
        func unsetIcon(for application: MacOSApplication.State) -> String {
            "\(iconsur) unset \\\"\(application.url.path)\\\"; "
        }
        
        /// Creates an and outputs a customized MacOSApplication icon.
        func createIcon(for application: MacOSApplication.State) -> String {
            "\(iconsur) set \\\"\(application.url.path)\\\" -l -s 0.8 -o \(output)\(application.name).png -c \(application.color); "
        }
        
        /// Sets a customized icon for a MacOSApplication.
        func setIcon(for application: MacOSApplication.State) -> String {
            "\(iconsur) set \\\"\(application.url.path)\\\" -l \(output)\(application.name).png; "
        }
        
        /// Modifies System Application Icons.
        func modifySystemApplicationIcons(_ applications: [MacOSApplication.State]) -> Result<Bool, Error> {
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
                .appending("/usr/local/bin/iconsur cache")
            
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
                switch environment.modifySystemApplicationIcons(state.macOSApplications) {
                
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
                            //state.macOSApplications[index].selected.toggle()
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
                
            case .selectModifiedButtonTapped:
                Array(zip(state.macOSApplications.indices, state.macOSApplications))
                    .forEach { index, application in
                        if application.customized {
                            state.macOSApplications[index].selected = true
                        }
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
