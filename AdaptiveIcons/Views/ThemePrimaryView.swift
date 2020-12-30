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
    
    private func Searchbar(_ viewStore: ViewStore<AppState, AppAction>) -> AnyView {
        AnyView(
            ZStack {
                TextField(
                    "Search",
                    text: viewStore.binding(get: \.search, send: AppAction.searchEntry))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if viewStore.search.count > 0 {
                    HStack {
                        Spacer()
                        Button(action: {
                            viewStore.send(.clearSearch)
                            viewStore.send(.toggleShowingExpandedSearchBar)
                        }) {
                            Image(systemName: "multiply.circle.fill")
                        }
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(.gray)
                    }.padding(.horizontal, 6)
                }
            }
            
            .frame(minWidth: viewStore.isSearching ? 60.0 : 0.0, idealWidth: 200.0, maxWidth: 200.0)
        )
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                Grid(viewStore.search == ""
                        ? viewStore.icons
                        : viewStore.icons.filter { $0.name.uppercased().contains(viewStore.search.uppercased()) }
                ){ icon in
                    IconView(store: store, icon: icon)
                }.padding(16)
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
                    if viewStore.showingExpandedSearchBar {
                        HStack {
                            TextField(
                                "Search",
                                text: viewStore.binding(get: \.search, send: AppAction.searchEntry))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button(action: {
                                viewStore.send(.clearSearch)
                                viewStore.send(.toggleShowingExpandedSearchBar)
                            }) {
                                Image(systemName: "multiply.circle.fill")
                            }
                            .buttonStyle(PlainButtonStyle())
                            .foregroundColor(.gray)
                        }
                        .frame(minWidth: 60.0, idealWidth: 200.0, maxWidth: 200.0)
                        
                    }
                }
                ToolbarItem {
                    if !viewStore.showingExpandedSearchBar {
                        Button(action: { viewStore.send(.toggleShowingExpandedSearchBar) }) {
                            Image(systemName: "magnifyingglass")

                        }
                    }
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

