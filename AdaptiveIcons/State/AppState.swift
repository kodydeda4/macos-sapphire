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
    var allSelected = false
    var search: String = ""
    var showingExpandedSearchBar = false
    var selectedIconState = SelectedIconState()
}

enum AppAction {
    case loadIcons
    case toggleShowingExpandedSearchBar
    case searchEntry(String)
    case clearSearch
    case selectAll
    case applyChanges
    case resetChanges
    
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
        environment: { _ in SelectedIconEnvironment() }
    ),
    Reducer { state, action, environment in
        iddlog("action: '\(action)'")
        
        switch action {
        
        case .loadIcons:
            state.icons = Icon.loadIcons(fromPath: "/Applications")
            return .none
            
        case .applyChanges:
            iddlog("action: '\(action)'")
            
            let selectedIcons = state.icons
                .filter { state.selectedIconState.icons.contains($0) }
                .map { Icon(path: $0.path, iconTheme: state.selectedIconState.iconTheme) }
            
            let unselectedIcons = state.icons
                .filter { !state.selectedIconState.icons.contains($0) }
            
            state.icons = selectedIcons + unselectedIcons
            state.selectedIconState.icons = []
            return .none
            
        case .resetChanges:
            let selectedIcons = state.icons
                .filter { state.selectedIconState.icons.contains($0) }
                .map { Icon(path: $0.path, iconTheme: IconTheme()) }
            
            let unselectedIcons = state.icons
                .filter { !state.selectedIconState.icons.contains($0) }
            
            state.icons = selectedIcons + unselectedIcons
            state.selectedIconState.icons = []
            return .none
            
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
            
        case let .selectedIconAction(subAction):
            return .none
        }
    }
)
