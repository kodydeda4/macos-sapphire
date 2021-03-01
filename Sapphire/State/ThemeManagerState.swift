//
//  ThemeManagerState.swift
//  Sapphire
//
//  Created by Kody Deda on 1/9/21.
//


import Combine
import ComposableArchitecture
import SwiftUI

struct ThemeManager: Equatable {
    var themes: [ThemeState] = []
}

enum ThemeManagerAction {
    case theme(index: Int, action: ThemeAction)
    case addThemeButtonTapped
}

struct ThemeManagerEnvironement {}

let themeManagerReducer = Reducer<ThemeManager, ThemeManagerAction, ThemeManagerEnvironement>.combine(
    themeReducer
        .forEach(
            state: \.themes,
            action: /ThemeManagerAction.theme(index:action:),
            environment: { _ in .init() }
        ),
    Reducer { state, action, environment in
        switch action {
        
        case .addThemeButtonTapped:
            state.themes.append(ThemeState())
            return .none

        default:
            return .none
        }
    }
)
.signpost()

extension ThemeManager {
    static let defaultStore = Store(
        initialState: ThemeManager(),
        reducer: themeManagerReducer,
        environment: ThemeManagerEnvironement()
    )
}
