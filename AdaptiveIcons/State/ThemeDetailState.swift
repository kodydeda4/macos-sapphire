//
//  SelectedIconState.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/31/20.
//

import Combine
import ComposableArchitecture
import SwiftUI

struct ThemeDetailState: Equatable {
    var icons = [Icon]()
    var iconTheme = IconTheme()
}

enum ThemeDetailAction {
    case toggleSelected(Icon)
    case setShape(IconShape)
    case setBackgroundColor(Color)
    case toggleShapeShadow(Bool)
    case toggleIconShadow(Bool)
}

struct ThemeDetailEnvironment {
}

extension ThemeDetailState {
    static let defaultStore = Store(
        initialState: ThemeDetailState(icons: Icon.loadIcons(fromPath: "/Applications")),
        reducer: themeDetailReducer,
        environment: ThemeDetailEnvironment()
    )
}

let themeDetailReducer = Reducer<ThemeDetailState, ThemeDetailAction, ThemeDetailEnvironment>.combine(
        
    Reducer { state, action, environment in
        iddlog("action: '\(action)'")
        
        switch action {
        
        case let .toggleSelected(icon):
            var icons = Set(state.icons)
            
            if icons.contains(icon) {
                icons.remove(icon)
            } else {
                icons.insert(icon)
            }
            
            state.icons = Array(icons)
            return .none
            
        case let .setShape(iconShape):
            state.iconTheme.shape = iconShape
            return .none
            
        case let .setBackgroundColor(color):
            state.iconTheme.backgroundColor = color
            return .none
            
        case let .toggleShapeShadow(selection):
            state.iconTheme.shapeShadow = selection
            return .none
            
        case let .toggleIconShadow(selection):
            state.iconTheme.iconShadow = selection
            return .none
            
        }
    }
)

extension ThemeDetailState {
    var iconDetailViewText: Text {
        return icons.count == 1
            ? Text(icons.first!.name)
            : Text("Preview")
    }

    var iconDetailViewImage: Image {
        return icons.count == 1
            ? Image(nsImage: icons.first!.appIcon)
            : Image(systemName: "scribble.variable")
    }
}
