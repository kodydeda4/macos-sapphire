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
        var gridSelections: [MacOSApplication.State] {
            macOSApplications.filter(\.selected)
        }
    }
    
    enum Action: Equatable {
        case macOSApplication(index: Int, action: MacOSApplication.Action)
        case createIconButtonTapped
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
                return .none

            case .applyChanges:
                return .none
                
            case .resetChanges:
                return .none
                
            case .selectAllButtonTapped:
                print("Selected All")
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
