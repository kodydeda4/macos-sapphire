//
//  SelectedIconState.swift
//  Sapphire
//
//  Created by Kody Deda on 12/31/20.
//

import Combine
import ComposableArchitecture
import SwiftUI

struct ThemeDetailState: Equatable {
    var selectedIcons = [Icon]()
    var iconTheme = IconTheme(shape: .roundedRectangle)
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
        initialState: ThemeDetailState(selectedIcons: Icon.loadIcons(fromPath: "/Applications")),
        reducer: themeDetailReducer,
        environment: ThemeDetailEnvironment()
    )
}

let themeDetailReducer = Reducer<ThemeDetailState, ThemeDetailAction, ThemeDetailEnvironment>.combine(
        
    Reducer { state, action, environment in
        iddlog("action: '\(action)'")
        
        switch action {
        
        case let .toggleSelected(icon):
            var icons = Set(state.selectedIcons)
            
            if icons.contains(icon) {
                icons.remove(icon)
            } else {
                icons.insert(icon)
            }
            
            state.selectedIcons = Array(icons)
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
        return selectedIcons.count == 1
            ? Text(selectedIcons.first!.name)
            : Text("Preview")
    }

    var iconDetailViewImage: Image {
        return selectedIcons.count == 1
            ? Image(nsImage: selectedIcons.first!.appIcon)
            : Image(systemName: "scribble.variable")
    }
    
}
