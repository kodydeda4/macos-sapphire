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
struct SelectedIconState: Equatable {
    var icons = [Icon]()
    // these are the selected icons ...
    
    var iconBackgroundColors = [Color.blue, .purple, .pink, .red, .orange, .yellow, .green, .gray, .black, .white]
    var selectedIconShape: IconShape? = .roundedRectangle
    var selectedBackgroundColor: Color = .white
    var shapeShadow = true
    var iconShadow  = false
}

enum SelectedIconAction {
    case toggleSelected(Icon)
    
    // ThemeDetailView
    case applyChanges
    case removeChanges
    case setSelectedIconShape(IconShape)
    case setSelectedBackgroundColor(Color)
    case toggleShapeShadow(Bool)
    case toggleIconShadow(Bool)
}

struct SelectedIconEnvironment {
}

extension SelectedIconState {
    static let defaultStore = Store(
        initialState: SelectedIconState(icons: Icon.loadIcons(fromPath: "/Applications")),
        reducer: selectedIconReducer,
        environment: SelectedIconEnvironment()
    )
}

let selectedIconReducer = Reducer<SelectedIconState, SelectedIconAction, SelectedIconEnvironment>.combine(
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

        // MARK:- ThemeDetailView
        case .applyChanges:
            state.icons = state.icons.reduce(into: [Icon]()) { partial, nextItem in
                var item = nextItem

                item.shape = state.selectedIconShape
                item.backgroundColor = state.selectedBackgroundColor
                item.iconShadow = state.iconShadow
                item.shapeShadow = state.shapeShadow
                
                partial.append(item)
            }

            
//            state.icons = state.icons.reduce(into: [Icon]()) { partial, nextItem in
//                var item = nextItem
//
//                if item.selected {
//                    item.shape = state.selectedIconShape
//                    item.backgroundColor = state.selectedBackgroundColor
//                    item.iconShadow = state.iconShadow
//                    item.shapeShadow = state.shapeShadow
//                }
//                partial.append(item)
//            }
            return .none
            
        case .removeChanges:
//            state.icons = state.icons.reduce(into: [Icon]()) { partial, nextItem in
//                var item = nextItem
//                
//                if item.selected {
//                    item.shape = .none
//                    item.backgroundColor = .none
//                    item.iconShadow = false
//                    item.shapeShadow = false
//                }
//                
//                partial.append(item)
//            }
            return .none
            
        case let .setSelectedIconShape(iconShape):
            state.selectedIconShape = iconShape
            return .none
            
        case let .setSelectedBackgroundColor(color):
            state.selectedBackgroundColor = color
            return .none
            
        case let .toggleShapeShadow(selection):
            state.shapeShadow = selection
            return .none
            
        case let .toggleIconShadow(selection):
            state.iconShadow = selection
            return .none
            
        }
    }
)

extension SelectedIconState {
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
