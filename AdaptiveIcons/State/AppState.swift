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
    var selectedIconShape: IconShape = .roundedRectangle
    var selectedBackgroundColor: Color = .white
    var selectedShadow: Bool = false
}

enum AppAction {
    case loadIcons
    case toggleSelected(Icon)
    
    case setSelectedBackgroundColor(Color)
    case setSelectedIconShape(IconShape)
    case setSelectedShadow(Bool)
    
    case applyChanges
    case removeChanges
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
            
        case let .toggleSelected(icon):
            guard let index = state.icons.firstIndex(of: icon)
            else { return .none }
            state.icons[index].selected.toggle()
            return .none

        case .applyChanges:
            state.icons = state.icons.reduce(into: [Icon]()) { partial, nextItem in
                var item = nextItem
                
                if item.selected {
                    item.shape = state.selectedIconShape
                    item.backgroundColor = state.selectedBackgroundColor
                    item.shadow = state.selectedShadow
                }

                partial.append(item)
            }
            return .none
            
        case let .setSelectedIconShape(iconShape):
            state.selectedIconShape = iconShape
            return .none
            
        case let .setSelectedBackgroundColor(color):
            state.selectedBackgroundColor = color
            return .none
            
        case let .setSelectedShadow(selection):
            state.selectedShadow = selection
            return .none
            
        case .removeChanges:
            state.icons = state.icons.reduce(into: [Icon]()) { partial, nextItem in
                var item = nextItem
                
                if item.selected {
                    item.shape = .none
                    item.backgroundColor = .none
                    item.shadow = false
                }

                partial.append(item)
            }
            return .none
        }
        
    }
)
