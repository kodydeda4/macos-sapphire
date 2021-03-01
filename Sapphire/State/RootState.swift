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
    var themeManager = ThemeManager()
}

enum RootAction {
    case themeManager(ThemeManagerAction)
}

struct RootEnvironment {}
    
let rootReducer = Reducer<RootState, RootAction, RootEnvironment>.combine(
    themeManagerReducer
        .pullback(
            state: \.themeManager,
            action: /RootAction.themeManager,
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
