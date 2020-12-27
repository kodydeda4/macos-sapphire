//
//  AppState.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/24/20.
//

import Combine
import ComposableArchitecture
import SwiftUI

struct AppState: Equatable {
    var icons = [Icon]()
    //var background = Color.red
}

enum AppAction {
    case loadIcons
    case toggleSelection(Icon)
    case setBackgroundForSelectedIcons(Color)
}

struct AppEnvironment {
    
}

let defaultStore = Store(
    initialState:AppState(icons: Icon.loadIcons(fromPath: "/Applications")),
    reducer: appReducer,
    environment: AppEnvironment()
)

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    Reducer { state, action, environment in
        iddlog("action: '\(action)'")
        
        switch action {
        
        case .loadIcons:
            state.icons = Icon.loadIcons(fromPath: "/Applications")
            return .none
            
        case let .toggleSelection(appIcon):
            guard let index = state.icons.firstIndex(of: appIcon)
            else { return .none }
            state.icons[index].isSelected.toggle()
            return .none
            
        case let .setBackgroundForSelectedIcons(color):
            state.icons = state.icons.reduce(into: [Icon]()) { partial, nextItem in
                var item = nextItem
                item.isSelected ? item.background = color : ()
                partial.append(item)
            }
            return .none
        }
    }
)
