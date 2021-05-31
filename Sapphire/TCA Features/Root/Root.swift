//
//  Root.swift
//  Sapphire
//
//  Created by Kody Deda on 5/31/21.
//

import SwiftUI
import ComposableArchitecture

struct Root {
    struct State: Equatable {
        // state
    }
    
    enum Action: Equatable {
        // action
    }
    
    struct Environment {
        // environment
    }
}

extension Root {
    static let reducer = Reducer<State, Action, Environment>.combine(
        // pullbacks
        Reducer { state, action, environment in
            switch action {
            
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

// MARK:- RootView

struct RootView: View {
    let store: Store<Root.State, Root.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: Root.defaultStore)
    }
}
