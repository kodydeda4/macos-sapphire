//
//  ThemePrimaryView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI
import Combine
import ComposableArchitecture
import Grid

struct ThemePrimaryView: View {
    let store: Store<ThemeState, ThemeAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                iconGrid
            }
            .toolbar {
                ToolbarItem { selectAllButton }
                ToolbarItem { searchBar }
                ToolbarItem { resetChangesButton }
                ToolbarItem { applyChangesButton }
            }
        }
    }
}





// MARK:- HelperViews

extension ThemePrimaryView {
    
    var iconGrid: some View {
        WithViewStore(store) { viewStore in
            Grid(viewStore.search == ""
                    ? viewStore.icons
                    : viewStore.icons.filter {
                        $0.name.uppercased().contains(viewStore.search.uppercased())
                    }
            ) { icon in
                IconView(store: store, icon: icon)
            }
            .padding(16)
        }
    }
    
    var selectAllButton: some View {
        WithViewStore(store) { viewStore in
            Button("Select All") { viewStore.send(.selectAll) }
        }
    }
    
    var searchBar: some View {
        WithViewStore(store) { viewStore in
            SearchbarView(
                text: viewStore.binding(
                    get: \.search,
                    send: ThemeAction.searchEntry))
        }
    }
    
    var resetChangesButton: some View {
        WithViewStore(store) { viewStore in
            Button("Reset Changes") { viewStore.send(.resetChanges) }
        }
    }
    
    var applyChangesButton: some View {
        WithViewStore(store) { viewStore in
            Button("Apply Changes") { viewStore.send(.applyChanges) }
        }
    }
}

// MARK:- SwiftUI Previews

struct ThemePrimaryView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePrimaryView(store: ThemeState.defaultStore)
    }
}

