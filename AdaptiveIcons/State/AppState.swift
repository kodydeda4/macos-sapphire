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
    
    var selectedAppIcons: [Model.App] {
        appIcons.filter(\.isSelected)
    }
    var background = Color.red
}

enum AppAction {
    case loadIcons
    case toggleSelection(Model.App)
    case setBackgroundForSelectedApps(Color)
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
            
        case let .toggleSelection(appIcon):
            guard let index = state.appIcons.firstIndex(of: appIcon)
            else { return .none }
            state.appIcons[index].isSelected.toggle()
            return .none
            
        case let .setBackgroundForSelectedApps(color):
            iddlog("add a white background to \(state.selectedAppIcons.map(\.name))")
                        
            state.appIcons = state.appIcons.reduce(into: [Model.App]()) { partial, nextItem in
                var item = nextItem
                item.isSelected ? item.background = color : ()
                partial.append(item)
            }
            return .none
        }
    }
)


