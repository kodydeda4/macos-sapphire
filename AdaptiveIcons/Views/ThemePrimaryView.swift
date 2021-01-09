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
                grid
            }
            .toolbar {
                ToolbarItem {
                    Toggle(isOn: viewStore.binding(
                            get: \.allSelected,
                            send: ThemeAction.selectAll)) {
                        Text("Select All")
                    }
                }
                ToolbarItem {
                    SearchbarView(text: viewStore.binding(
                                            get: \.search,
                                            send: ThemeAction.searchEntry))
                }
                ToolbarItem {
                    HStack {
                        Button("Apply Changes", action: { viewStore.send(.applyChanges) })
                            .buttonStyle(RoundedRectangleButtonStyle())
                        
                        Button("Reset Changes", action: { viewStore.send(.resetChanges) })
                            .buttonStyle(RoundedRectangleButtonStyle())
                    }
                }
            }
        }
    }
    
    
    var grid: some View {
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
}



struct ThemePrimaryView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePrimaryView(store: ThemeState.defaultStore)
    }
}

