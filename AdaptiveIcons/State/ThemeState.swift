//
//  AppState.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/24/20.
//


import Combine
import ComposableArchitecture
import SwiftUI

struct ThemeState: Equatable, Identifiable {
    let id = UUID()
    var name: String = "My Theme"
    var icons: [Icon] = Icon.loadIcons(fromPath: "/Applications")
    var filteredIcons = Icon.loadIcons(fromPath: "/Applications")
    
    var allSelected = false
    var iconFilter: String = ""
    var showingExpandedSearchBar = false
    var selectedIconState = ThemeDetailState()
}

enum ThemeAction {
    case loadIcons
    case toggleShowingExpandedSearchBar
    case iconFilterChanged(String)
    case clearSearch
    case selectAll
    case applyChanges
    case resetChanges
    case selectedIconAction(ThemeDetailAction)
    case nameChanged(String)
}

struct ThemeEnvironment {
    
}

extension ThemeState {
    static let defaultStore = Store(
        initialState: ThemeState(name: "", icons: Icon.loadIcons(fromPath: "/Applications")),
        reducer: themeReducer,
        environment: ThemeEnvironment()
    )
}

let themeReducer = Reducer<ThemeState, ThemeAction, ThemeEnvironment>.combine(
    themeDetailReducer.pullback(
        state: \.selectedIconState,
        action: /ThemeAction.selectedIconAction,
        environment: { _ in ThemeDetailEnvironment() }
    ),
    Reducer { state, action, environment in
        iddlog("action: '\(action)'")
        
        switch action {
        
        case .loadIcons:
            state.icons = Icon.loadIcons(fromPath: "/Applications")
            return .none
            
        case let .nameChanged(text):
            state.name = text
            return .none
            
        case .applyChanges:
            iddlog("action: '\(action)'")
            
            let selectedIcons = state.icons
                .filter { icon in state.selectedIconState.selectedIcons.contains(icon) }
                .map { Icon(path: $0.path, iconTheme: state.selectedIconState.iconTheme) }
            
            let unselectedIcons = state.icons
                .filter { !state.selectedIconState.selectedIcons.contains($0) }
            
            state.icons = Array(selectedIcons + unselectedIcons).sorted(by: { $0.name < $1.name })
            state.filteredIcons = state.icons
            state.selectedIconState.selectedIcons = []
            return .none
            
        case .resetChanges:
            let selectedIcons = state.icons
                .filter { state.selectedIconState.selectedIcons.contains($0) }
                .map { Icon(path: $0.path, iconTheme: IconTheme()) }
            
            let unselectedIcons = state.icons
                .filter { !state.selectedIconState.selectedIcons.contains($0) }
            
            state.icons = Array(selectedIcons + unselectedIcons).sorted(by: { $0.name < $1.name })
            state.filteredIcons = state.icons
            state.selectedIconState.selectedIcons = []
            return .none
            
        case .clearSearch:
            state.iconFilter = ""
            return .none
            
        case .toggleShowingExpandedSearchBar:
            state.showingExpandedSearchBar.toggle()
            return .none
            
        case .selectAll:
            state.allSelected.toggle()
            state.selectedIconState.selectedIcons = state.allSelected
                ? state.icons
                : []
            return .none
            
        case let .iconFilterChanged(text):
            state.iconFilter = text
            if text == "" {
                state.filteredIcons = state.icons
            } else {
                state.filteredIcons = state.icons.filter{ $0.name.uppercased().contains(text.uppercased()) }
            }
            return.none
            
        case let .selectedIconAction(subAction):
            return .none
        }
    }
)


