//
//  AppState.swift
//  AdaptiveIcons
//
//  Created by Klajd Deda on 12/24/20.
//

import Combine
import ComposableArchitecture
import SwiftUI

// MARK: - AppState

struct AppState: Equatable {
    var appIcons = [Model.App]()
    var selectedAppIcons = Set<Model.App>()
}

// MARK: - AppAction

enum AppAction {
    case loadIcons
    case toggle(Model.App)
}

// MARK: - AppEnvironment

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
}

let defaultStore = Store(
    initialState:
        AppState(
            appIcons: Model.App.loadAppIcons(fromPath: "/Applications")
        ),
    reducer:
        appReducer,
    environment:
        AppEnvironment(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            uuid: UUID.init
        )
)

let mockupStore = Store(
    initialState: AppState(
        appIcons: [
            Model.App(path: "/Applications/Xcode.app"),
            Model.App(path: "/Applications/Pages.app")
        ],
        selectedAppIcons: Set(arrayLiteral: Model.App(path: "/Applications/Pages.app"))
    ),
    reducer: appReducer,
    environment: AppEnvironment(
        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
        uuid: UUID.init
    )
)

// MARK: - Reducer (AppState, AppAction)
let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    Reducer { state, action, environment in
        iddlog("action: '\(action)'")
        
        switch action {
        case .loadIcons:
            state.appIcons = Model.App.loadAppIcons(fromPath: "/Applications")
            return .none
            
        case let .toggle(appIcon):
            if state.selectedAppIcons.contains(appIcon) {
                state.selectedAppIcons.remove(appIcon)
            } else {
                state.selectedAppIcons.insert(appIcon)
            }
            return .none
        }
    }
)
