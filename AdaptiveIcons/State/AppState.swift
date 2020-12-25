//
//  AppState.swift
//  AdaptiveIcons
//
//  Created by Klajd Deda on 12/24/20.
//

import Combine
import ComposableArchitecture
import SwiftUI

struct AppState: Equatable {
    var appIcons = [Model.App]()
    var selectedAppIcons = Set<Model.App>()
}

enum AppAction {
    case loadIcons
    case toggle(Model.App)
}

struct AppEnvironment {

}

let defaultStore = Store(
    initialState:AppState(appIcons: Model.App.loadAppIcons(fromPath: "/Applications")),
    reducer: appReducer,
    environment: AppEnvironment()
)

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


