//
//  RootState.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 1/8/21.
//

import Combine
import ComposableArchitecture
import SwiftUI

struct RootState {
    var theme = ThemeState()
}

enum RootAction {
    case theme(ThemeAction)
}

struct RootEnvironment {
    
}

let rootReducer = Reducer<RootState, RootAction, RootEnvironment>.combine(
    themeReducer
        .pullback(
            state: \.theme,
            action: /RootAction.theme,
            environment: { _ in .init() }
        ),

    Reducer { state, action, environment in
        switch action {
        default:
            return .none
        }
    }
)

extension RootState {
    static let defaultStore = Store(
        initialState: RootState(),
        reducer: rootReducer,
        environment: RootEnvironment()
    )
}
