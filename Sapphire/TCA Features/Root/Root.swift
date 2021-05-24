//
//  Root.swift
//  Sapphire
//
//  Created by Kody Deda on 5/20/21.
//

import SwiftUI
import ComposableArchitecture

struct Root {
    struct State: Equatable {
        var grid = Grid.State()
    }
    
    enum Action: Equatable {
        case onAppear
        case grid(Grid.Action)
        case save
    }
    
    struct Environment {
        //let dataURL = Bundle.main.bundleURL.appendingPathComponent("SapphireState.json")
        let dataURL = URL(fileURLWithPath: "SapphireState.json", relativeTo: URL(fileURLWithPath: NSHomeDirectory()))
    }
}

extension Root {
    static let reducer = Reducer<State, Action, Environment>.combine(
        Grid.reducer.pullback(
            state: \.grid,
            action: /Action.grid,
            environment: { _ in .init() }
        ),
        Reducer { state, action, environment in
            switch action {
            
            case .onAppear:
                switch JSONDecoder().decodeState(
                    ofType: Grid.State.self,
                    from: environment.dataURL
                ) {
                case let .success(decodedState):
                    state.grid = decodedState
                case let .failure(error):
                    print(error.localizedDescription)
                }
                return .none
                
                
            case .save:
                let _ = JSONEncoder().writeState(state.grid, to: environment.dataURL)
                return .none
                
            case let .grid(action):
                switch action {

                case .updateGridSelections, .macOSApplication:
                    return .none
                    
                default:
                    return Effect(value: .save)
                
                }
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
