//
//  AppState.swift
//  Sapphire
//
//  Created by Kody Deda on 12/24/20.
//

import Combine
import ComposableArchitecture
import SwiftUI

/*
 
 Todo:
 
 Create a TCA Feature for-each MacOSApplication.
    - String name
    - String icon
 
 */

struct Root {
    struct State: Equatable {
        var foo: String = ""
        var apps: [MacOSApplication] = .allCases
    }
    
    enum Action: Equatable {
        case applyChanges
        case resetChanges
    }
    
    struct Environment {
        // environment
    }
}

extension Root {
    static let reducer = Reducer<State, Action, Environment>.combine(
        Reducer { state, action, environment in
            switch action {
            
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
