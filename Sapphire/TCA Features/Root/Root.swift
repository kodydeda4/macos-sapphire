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
        var sheetView = false
        var animatingApplyChanges = false
    }
    
    enum Action: Equatable {
        case macOSApplication(index: Int, action: MacOSApplication.Action)
        case save
        case onAppear
        case createIconButtonTapped
        case toggleSheetView
        case selectAllButtonTapped
        case applyChanges
        case resetChanges
        case updateIcon(MacOSApplication.State)
        case updateGridSelections(Int)
    }
    
    struct Environment {
        let dataURL = URL(fileURLWithPath: "SapphireState.json", relativeTo: URL(fileURLWithPath: NSHomeDirectory()))
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
                let command = Array(zip(state.macOSApplications.indices, state.macOSApplications))
                    .filter { $1.selected }
                    .map {
                        $1.customized
                            ? "/usr/local/bin/iconsur unset \\\"\($1.url.path)\\\"; "
                            : "/usr/local/bin/iconsur set \\\"\($1.url.path)\\\" -l -s 0.8; "
                    }
                    .joined()
                
                let lastCommand = command + "/usr/local/bin/iconsur cache"

                
                let _ = AppleScript.execute(command: lastCommand, sudo: true)
                
                Array(zip(state.macOSApplications.indices, state.macOSApplications))
                    .forEach { index, application in
                        if state.macOSApplications[index].selected {
                            state.macOSApplications[index].customized.toggle()
                        }
                    }

                return .none
//                let app = state.macOSApplications.filter(\.selected).first!
//                let _ = AppleScript.execute(
//                    command: "/usr/local/bin/iconsur set \(app.url.path) -l -s 0.8; /usr/local/bin/iconsur cache",
//                    sudo: true
//                )
//                state.animatingApplyChanges.toggle()
//                if state.animatingApplyChanges {
//                    return Effect(value: .toggleSheetView)
//                }
//                state.animatingApplyChanges.toggle()
//                return Effect(value: .updateIcon(app))
                
            case let .updateIcon(app):
                let index = state.macOSApplications.firstIndex(of: app)

                return Effect(value: .macOSApplication(index: index!, action: .toggleCustom))
                
            case .applyChanges:
                return .none
                
            case .resetChanges:
                return .none
                
            case .selectAllButtonTapped:
                print("Selected All")
                return .none
                
            case .toggleSheetView:
                state.sheetView.toggle()
                
                if state.sheetView {
                    return Effect(value: .toggleSheetView)
                        .delay(for: 10.0, scheduler: DispatchQueue.main)
                        .eraseToEffect()
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
