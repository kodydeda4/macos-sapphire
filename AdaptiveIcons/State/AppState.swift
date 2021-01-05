//
//  AppState.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/24/20.
//

import Combine
import ComposableArchitecture
import SwiftUI

// TODO
// create a separate state for the selected icons
// than actions and reducer for that
//
struct AppState: Equatable {
    
    // App
    var icons = [Icon]()
    var allSelected = false
    
    // ThemePrimaryView
    var search: String = ""
    var showingExpandedSearchBar = false
        
    var selectedIconState = SelectedIconState()
}

enum AppAction {
    // App
    case loadIcons
    
    // ThemePrimaryView
    case toggleShowingExpandedSearchBar
    case searchEntry(String)
    case clearSearch
    case selectAll
    case applyTheme
    
    case selectedIconAction(SelectedIconAction)
}

struct AppEnvironment {
    
}

extension AppState {
    static let defaultStore = Store(
        initialState: AppState(icons: Icon.loadIcons(fromPath: "/Applications")),
        reducer: appReducer,
        environment: AppEnvironment()
    )
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    selectedIconReducer.pullback(
        state: \.selectedIconState,
        action: /AppAction.selectedIconAction,
        environment: { _ in SelectedIconEnvironment() }),
    Reducer { state, action, environment in
        iddlog("action: '\(action)'")
        
        switch action {
        
        // MARK:- App
        case .loadIcons:
            state.icons = Icon.loadIcons(fromPath: "/Applications")
            return .none
            
        case .applyTheme:
            iddlog("action: '\(action)'")
            return .none
            
        // MARK:- ThemePrimaryView
        case .clearSearch:
            state.search = ""
            return .none
            
        case .toggleShowingExpandedSearchBar:
            state.showingExpandedSearchBar.toggle()
            return .none
            
        case .selectAll:
            state.allSelected.toggle()
            state.selectedIconState.icons = state.allSelected
                ? state.icons
                : []
            return .none
            
        case let .searchEntry(text):
            state.search = text
            return.none
            
            
//        // MARK:- ThemeDetailView
//        case .applyChanges:
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
//            return .none
//
//        case .removeChanges:
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
//            return .none
//
//        case let .setSelectedIconShape(iconShape):
//            state.selectedIconShape = iconShape
//            return .none
//
//        case let .setSelectedBackgroundColor(color):
//            state.selectedBackgroundColor = color
//            return .none
//
//        case let .toggleShapeShadow(selection):
//            state.shapeShadow = selection
//            return .none
//
//        case let .toggleIconShadow(selection):
//            state.iconShadow = selection
//            return .none
            

        case let .selectedIconAction(subAction):
            return .none
        }
    }
)
