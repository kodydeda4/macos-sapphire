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
            
            case let .macOSApplication(index, action):
                if action == .toggleSelected {
                    return Effect(value: .updateGridSelections(index))
                }
                return .none
                
            case let .updateGridSelections(index):
                state.macOSApplications[index].selected.toggle()
                print(state.macOSApplications.filter(\.selected).count)
                return .none


                
            // The problem here is that DetailView SHOULD be takinig the store of the first selected icon.
            // That store will send action `update icon`
            // And can come back here inside the `switch subaction`.
            
            case .createIconButtonTapped:
                print("Update: \(state.macOSApplications.filter(\.selected).map(\.name).description)")
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

extension Root {
    static let defaultStore = Store(
        initialState: .init(),
        reducer: reducer,
        environment: .init()
    )
}
