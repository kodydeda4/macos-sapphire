//
//  Root.swift
//  Sapphire
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI
import ComposableArchitecture

struct Root {
    struct State: Equatable {
        var macOSApplications : [MacOSApplication.State] = .allCases
        var sheetView = false
        var animatingApplyChanges = false
    }
    
    enum Action: Equatable {
        case macOSApplication(index: Int, action: MacOSApplication.Action)
        case createIconButtonTapped
        case toggleSheetView
        case selectAllButtonTapped
        case applyChanges
        case resetChanges
        case updateIcon(MacOSApplication.State)
        case updateGridSelections(Int)
    }
    
    struct Environment {
        
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
                return .none
                
            case let .updateGridSelections(index):
                state.macOSApplications[index].selected.toggle()
                print("selections: \(state.macOSApplications.filter(\.selected).map(\.name))")
                return .none


                
            // The problem here is that DetailView SHOULD be takinig the store of the first selected icon.
            // That store will send action `update icon`
            // And can come back here inside the `switch subaction`.
            
            case .createIconButtonTapped:
                print("----------------")
                let command = Array(zip(state.macOSApplications.indices, state.macOSApplications))
                    .filter { $1.selected }
                    .map {
                        $1.customized
                            ? "/usr/local/bin/iconsur unset \($1.url.path.replacingOccurrences(of: " ", with: " \\")); "
                            : "/usr/local/bin/iconsur set \($1.url.path.replacingOccurrences(of: " ", with: " \\")) -l -s 0.8; "
                    }
                    .map { $0 + "/usr/local/bin/iconsur cache" }
                    .joined()
                
                    print(AppleScript.createShellCommand(command: command, sudo: true))
                AppleScript.execute(command: command, sudo: true)
                
                print("----------------")
                    
//                    .forEach {
//                        AppleScript.execute(
//                            command: $0,
//                            sudo: true
//                        )
//                    }
                        
                    
                
                //*
                //* Problems - 1. the script cannot determine the proper name eg: `Applications/Unsplash Wallpapers.app` should be Applications/Unsplash\ Wallpapers.app
                //*

                
//                print(environment.getIconsurCommand(state.macOSApplications))
                
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
