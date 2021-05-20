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
//        var animatingApplyChanges = false
    }
    
    enum Action: Equatable {
        case macOSApplication(index: Int, action: MacOSApplication.Action)
        case save
        case onAppear
        case createIconButtonTapped
//        case toggleSheetView
        case selectAllButtonTapped
        case updateIcons
        case updateGridSelections(Int)
    }
    
    struct Environment {
        let dataURL = URL(fileURLWithPath: "SapphireState.json", relativeTo: URL(fileURLWithPath: NSHomeDirectory()))
        
        func getCommand(_ applications: [MacOSApplication.State]) -> String {
            let command = Array(zip(applications.indices, applications))
                .filter { $1.selected }
                .map {
                    $1.customized
                        ? "/usr/local/bin/iconsur unset \\\"\($1.url.path)\\\"; "
                        : "/usr/local/bin/iconsur set \\\"\($1.url.path)\\\" -l -s 0.8; "
                }
                .joined()
            
            let f = command + "/usr/local/bin/iconsur cache"
            
            return "do shell script \"\(f)\" with administrator privileges"
            
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
                if action == .toggleSelected {
                    return Effect(value: .updateGridSelections(index))
                }
                return Effect(value: .save)
            
            case .save:
                let _ = JSONEncoder().writeState(state, to: environment.dataURL)
                return .none
                
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

            case .createIconButtonTapped:
                let result = AppleScript.execute(environment.getCommand(state.macOSApplications))
                switch result {
                
                // I want to wait for the process to complete.
                case .success:
                    return Effect(value: .updateIcons)
//                        .delay(for: 10.0, scheduler: DispatchQueue.main)
//                        .eraseToEffect()

                case let .failure(error):
                    print(error.localizedDescription)
                    return .none
                }
                                
            case .updateIcons:
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



extension String {
    func print() {
        Swift.print(self.description)
    }
}

extension Root {
    static let defaultStore = Store(
        initialState: .init(),
        reducer: reducer,
        environment: .init()
    )
}
