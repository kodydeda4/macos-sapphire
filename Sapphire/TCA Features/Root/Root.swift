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
        var macOSApplications: [MacOSApplication.State] = .allCases
        var sheetView = false
        var animatingApplyChanges = false
        var gridSelections: [MacOSApplication.State] {
            macOSApplications.filter(\.selected)
        }
    }
    
    enum Action: Equatable {
        case macOSApplication(index: Int, action: MacOSApplication.Action)
        case createIconButtonTapped
        case toggleSheetView
        case selectAllButtonTapped
        case applyChanges
        case resetChanges
    }
    
    struct Environment {
        // environment
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
            
            case .macOSApplication:
                return .none
                
            case .createIconButtonTapped:
                let _ = AppleScript.execute(
                    command: "/usr/local/bin/iconsur set \(state.gridSelections.first!.url.path) -l -s 0.8; /usr/local/bin/iconsur cache",
                    sudo: true
                )
                state.animatingApplyChanges.toggle()
                if state.animatingApplyChanges {
                    return Effect(value: .toggleSheetView)
                }
                state.animatingApplyChanges.toggle()
                return Effect(value: .toggleSheetView)
                
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
                        .delay(for: 2.0, scheduler: DispatchQueue.main)
                        .eraseToEffect()
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
