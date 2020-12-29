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
    var iconShapeSelection: IconShape = .roundedRectangle
    var backgroundColorSelection: Color = .white
}

enum AppAction {
    case loadIcons
    case toggleIsSelected(Icon)
    
    case applyChangesButtonPressed
    case setBackgroundColorSelection(Color)
    case setIconShapeSelection(IconShape)
}

struct AppEnvironment {
    
}

let defaultStore = Store(
    initialState: AppState(icons: Icon.loadIcons(fromPath: "/Applications")),
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
            
        case let .toggleIsSelected(appIcon):
            guard let index = state.icons.firstIndex(of: appIcon)
            else { return .none }
            state.icons[index].isSelected.toggle()
            return .none

        case let .setIconShapeSelection(iconShape):
            state.iconShapeSelection = iconShape
            return .none
            
        case let .setBackgroundColorSelection(color):
            state.backgroundColorSelection = color
            return .none
            
        case .applyChangesButtonPressed:
            state.icons = state.icons.reduce(into: [Icon]()) { partial, nextItem in
                var item = nextItem
                
                if item.isSelected {
                    item.shape = state.iconShapeSelection
                    item.backgroundColor = state.backgroundColorSelection
                }

                partial.append(item)
            }
            return .none
        }
    }
)
