//
//  AppState.swift
//  Sapphire
//
//  Created by Kody Deda on 12/24/20.
//

import Combine
import ComposableArchitecture
import SwiftUI

struct Root {
    struct State: Equatable {
        var foo: String = ""
        var icons: [Icon] = Icon.loadIcons(fromPath: "/Applications")
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

// MARK:- RootView

import Grid

struct RootView: View {
    let store: Store<Root.State, Root.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                Grid(viewStore.icons) { icon in
                    IconView(icon: icon)
                }
                .padding()
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: Root.defaultStore)
    }
}



