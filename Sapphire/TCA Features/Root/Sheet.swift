//
//  Sheet.swift
//  Sapphire
//
//  Created by Kody Deda on 5/25/21.
//

import SwiftUI
import ComposableArchitecture

struct Sheet {
    struct State: Equatable, Codable {
        var displayedView: DisplayedView = .onboarding
        
        enum DisplayedView: String, Codable, CaseIterable, Identifiable {
            var id: DisplayedView { self }
            case onboarding
        }
    }
    
    enum Action: Equatable {
        // action
    }
    
    struct Environment {
        // environment
    }
}

extension Sheet {
    static let reducer = Reducer<State, Action, Environment>.combine(
        // pullbacks
        Reducer { state, action, environment in
            switch action {
            
            }
        }
    )
}

extension Sheet {
    static let defaultStore = Store(
        initialState: .init(),
        reducer: reducer,
        environment: .init()
    )
}

