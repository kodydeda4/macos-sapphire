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
    
    // App
    var icons = [Icon]()
    var allSelected = false
    
    // ThemePrimaryView
    var search: String = ""
    var isSearching = false
    var showingExpandedSearchBar = false
    
    // ThemeDetailView
    var iconDetailViewText = Text("Preview")
    var iconDetailViewImage = Image(systemName: "scribble.variable")
    var selectedIconShape: IconShape? = .roundedRectangle
    var selectedBackgroundColor: Color = .white
    var shapeShadow = true
    var iconShadow  = false
    var iconBackgroundColors = [Color.blue, .purple, .pink, .red, .orange, .yellow, .green, .gray, .black, .white]
}

enum AppAction {
    // App
    case loadIcons
    
    // ThemePrimaryView
    case toggleIsSearching
    case toggleShowingExpandedSearchBar
    case searchEntry(String)
    case clearSearch
    case toggleSelected(Icon)
    case selectAll
    
    // ThemeDetailView
    case applyChanges
    case removeChanges
    case setSelectedIconShape(IconShape?)
    case setSelectedBackgroundColor(Color)
    case toggleShapeShadow(Bool)
    case toggleIconShadow(Bool)
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
        
        // MARK:- App
        case .loadIcons:
            state.icons = Icon.loadIcons(fromPath: "/Applications")
            return .none
            
        // MARK:- ThemePrimaryView
        case .clearSearch:
            state.search = ""
            return .none
            
        case .toggleIsSearching:
            state.isSearching.toggle()
            return .none
            
        case .toggleShowingExpandedSearchBar:
            state.showingExpandedSearchBar.toggle()
            return .none
            
        case let .toggleSelected(icon):
            // Update state.icons
            guard let index = state.icons.firstIndex(of: icon)
            else { return .none }
            state.icons[index].selected.toggle()
            
            // Update IconDetailView
            let selectedIcons = state.icons.filter(\.selected)
            state.iconDetailViewText = selectedIcons.count == 1
                ? Text(selectedIcons.first!.name)
                : Text("Preview")

            state.iconDetailViewImage = selectedIcons.count == 1
                ? Image(nsImage: selectedIcons.first!.appIcon)
                : Image(systemName: "scribble.variable")
            
            return .none
            
        case .selectAll:
            state.icons = state.icons.reduce(into: [Icon]()) { partial, nextItem in
                var item = nextItem
                item.selected = !state.allSelected
                partial.append(item)
            }
            state.allSelected.toggle()
            return .none
            
        case let .searchEntry(text):
            state.search = text
            return.none
            
        // MARK:- ThemeDetailView
        case .applyChanges:
            state.icons = state.icons.reduce(into: [Icon]()) { partial, nextItem in
                var item = nextItem
                
                if item.selected {
                    item.shape = state.selectedIconShape
                    item.backgroundColor = state.selectedBackgroundColor
                    item.iconShadow = state.iconShadow
                    item.shapeShadow = state.shapeShadow   
                }
                partial.append(item)
            }
            return .none
            
        case .removeChanges:
            state.icons = state.icons.reduce(into: [Icon]()) { partial, nextItem in
                var item = nextItem
                
                if item.selected {
                    item.shape = .none
                    item.backgroundColor = .none
                    item.iconShadow = false
                    item.shapeShadow = false
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

        case let .toggleShapeShadow(selection):
            state.shapeShadow = selection
            return .none
            
        case let .toggleIconShadow(selection):
            state.iconShadow = selection
            return .none
            

        }
    }
)
