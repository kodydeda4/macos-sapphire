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
    var search: String = ""
    var isSearching = false
    var numberOfIconsSelected = 0
    var selectedIconShape: IconShape? = .roundedRectangle
    var selectedBackgroundColor: Color = .white
    var shapeShadow: Bool = true
    var iconShadow: Bool = false
    var allSelected = false
    var showingExpandedSearchBar = false
}

enum AppAction {
    case loadIcons
    case clearSearch
    case toggleIsSearching
    case toggleSelected(Icon)
    case selectAll
    case setSelectedBackgroundColor(Color)
    case setSelectedIconShape(IconShape?)
    case toggleShapeShadow(Bool)
    case toggleIconShadow(Bool)
    case searchEntry(String)
    case applyChanges
    case removeChanges
    case toggleShowingExpandedSearchBar
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
            
            if state.icons[index].selected == true {
                state.numberOfIconsSelected += 1
            } else {
                state.numberOfIconsSelected -= 1
            }
            return .none

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
            
        case let .setSelectedIconShape(iconShape):
            state.selectedIconShape = iconShape
            
            return .none
            
        case let .setSelectedBackgroundColor(color):
            state.selectedBackgroundColor = color
            
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
            
        case .selectAll:
            state.icons = state.icons.reduce(into: [Icon]()) { partial, nextItem in
                var item = nextItem
                item.selected = !state.allSelected
                partial.append(item)
            }
            state.allSelected.toggle()
            if state.allSelected == true {
                state.numberOfIconsSelected = state.icons.count
            } else {
                state.numberOfIconsSelected = 0
            }
            return .none
            
        case let .toggleShapeShadow(selection):
            state.shapeShadow = selection
            return .none
            
        case let .toggleIconShadow(selection):
            state.iconShadow = selection
            return .none
        
        case let .searchEntry(text):
            state.search = text
            return.none
            
        case .toggleShowingExpandedSearchBar:
            state.showingExpandedSearchBar.toggle()
            return .none
        
        case .toggleIsSearching:
            state.isSearching.toggle()
            return .none
            
        case .clearSearch:
            state.search = ""
            return .none
        }
    }
)
