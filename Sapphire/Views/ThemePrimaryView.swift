//
//  ThemePrimaryView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/24/20.
//


import SwiftUI
import ComposableArchitecture
import Grid

struct ThemePrimaryView: View {
    let store: Store<ThemeState, ThemeAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                Grid(viewStore.filteredIcons) { icon in
                    IconView(store: store, icon: icon)
                }
                .padding(16)
            }
            .toolbar {
                ToolbarItem {
                    SearchbarView(text: viewStore.binding(get: \.iconFilter, send: ThemeAction.iconFilterChanged))
                }
                ToolbarItem {
                    Button("Select All") { viewStore.send(.selectAll) }
                }
                ToolbarItem {
                    Button("Reset Changes") { viewStore.send(.resetChanges) }
                }
                ToolbarItem {
                    Button("Apply Changes") { viewStore.send(.applyChanges) }
                }
            }
        }
    }
}

// MARK:- SwiftUI Previews

struct ThemePrimaryView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePrimaryView(store: ThemeState.defaultStore)
    }
}
