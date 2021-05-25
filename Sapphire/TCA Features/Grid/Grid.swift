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
    struct State: Equatable, Codable {
        var macOSApplications : [MacOSApplication.State] = .allCases
        var inFlight = false
    }
    
    enum Action: Equatable {
        case macOSApplication(index: Int, action: MacOSApplication.Action)
        case selectAllButtonTapped
        case selectModifiedButtonTapped
        case selectAll
        case deselectAll
        case modifySystemApplications
        case modifySystemApplicationsResult(Result<Bool, AppleScriptError>)
    }
    
    struct Environment {
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
            switch action {
            
            case let .macOSApplication(index, action):
                switch action {
                
                case .toggleSelected:
                    state.macOSApplications[index].selected.toggle()
                    return .none
                    
                case .modifyIconButtonTapped:
                    return Effect(value: .modifySystemApplications)
                    
                default:
                    break
                }
                return .none
                
                
            case .modifySystemApplications:
                state.inFlight = true
                return environment.modifySystemApplicationIcons(state.macOSApplications.filter(\.selected))
                
            case .modifySystemApplicationsResult(.success):
                state.inFlight = false
                
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
                return Effect(value: .deselectAll)
                
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
