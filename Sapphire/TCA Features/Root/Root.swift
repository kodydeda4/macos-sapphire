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
        var macOSApplication: [MacOSApplication.State] = Bundle.allBundleURLs.map { url in
            MacOSApplication.State(
                path: url,
                name: Bundle.name(from: url),
                icon: Bundle.icon(from: url)
            )
        }
    }
    
    enum Action: Equatable {
        case macOSApplication(index: Int, action: MacOSApplication.Action)
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
            state: \.macOSApplication,
            action: /Action.macOSApplication(index:action:),
            environment: { _ in () }
        ),
        Reducer { state, action, environment in
            switch action {
            
            case .macOSApplication:
                return .none

            case .applyChanges:
                return .none
                
            case .resetChanges:
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
