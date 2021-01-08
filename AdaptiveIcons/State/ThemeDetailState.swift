//
//  SelectedIconState.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/31/20.
//

import Combine
import ComposableArchitecture
import SwiftUI

/**
 Models an array of selected icons and actions to them
 */
struct ThemeDetailState: Equatable {
    // these are the selected icons ...
    var icons = [Icon]()
    var iconTheme = IconTheme()
    
    var iconBackgroundColors: [Color] = [.blue, .purple, .pink, .red, .orange, .yellow, .green, .gray, .black, .white]
    var selectedIconShape = IconTheme().shape
    var selectedBackgroundColor: Color = IconTheme().backgroundColor
    var shapeShadow = IconTheme().shapeShadow
    var iconShadow  = IconTheme().iconShadow
}

enum ThemeDetailAction {
    case toggleSelected(Icon)
//    case applyChanges
//    case removeChanges
    case setSelectedIconShape(IconShape)
    case setSelectedBackgroundColor(Color)
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

//        case .applyChanges:
//            state.icons = state.icons.map { Icon(path: $0.path, iconTheme: state.iconTheme) }
//            return .none
//
//        case .removeChanges:
//            state.icons = state.icons.map { Icon(path: $0.path, iconTheme: IconTheme()) }
//            return .none
            
        case let .setSelectedIconShape(iconShape):
            state.selectedIconShape = iconShape
            state.iconTheme.shape = iconShape
            return .none
            
        case let .setSelectedBackgroundColor(color):
            state.selectedBackgroundColor = color
            state.iconTheme.backgroundColor = color
            return .none
            
        case let .toggleShapeShadow(selection):
            state.shapeShadow = selection
            state.iconTheme.shapeShadow = selection
            return .none
            
        case let .toggleIconShadow(selection):
            state.iconShadow = selection
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
