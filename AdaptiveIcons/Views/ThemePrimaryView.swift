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
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                Grid(viewStore.search == ""
                        ? viewStore.icons
                        : viewStore.icons.filter { $0.name.uppercased().contains(viewStore.search.uppercased())}) {
                    icon in IconView(store: store, icon: icon)
                }
                .padding(16)
            }
            .toolbar(content: {
                ToolbarItem {
                    Toggle(isOn: viewStore.binding(
                            get: \.allSelected,
                            send: AppAction.selectAll)) {
                        Text("Select All")
                    }
                }
                ToolbarItem {
                    SearchbarView(store: store)
                }
                ToolbarItem {
                    Button("Apply Theme", action: { viewStore.send(.applyTheme) })
                        .buttonStyle(RoundedRectangleButtonStyle())
                }
            })
        }
    }
    
}

struct ThemePrimaryView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePrimaryView(store: defaultStore)
    }
}

