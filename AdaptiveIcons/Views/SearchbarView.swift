//
//  SearchbarVuew.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/31/20.
//

import SwiftUI
import ComposableArchitecture
import Grid
import Combine

struct SearchbarView: View {
    let store: Store<ThemeState, ThemeAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if viewStore.showingExpandedSearchBar {
                expandedSearchBarView
            } else {
                compactSearchBarView
            }
        }
    }
    
    // MARK:- Compact
    
    var compactSearchBarView: some View {
        WithViewStore(store) { viewStore in
            Button(action: { viewStore.send(.toggleShowingExpandedSearchBar) }) {
                Image(systemName: "magnifyingglass")
            }
        }
    }
    
    // MARK:- Expanded
    
    var expandedSearchBarView: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                textfield
                if viewStore.search.count > 0 {
                    roundCancelButton
                }
            }
            .frame(minWidth: 60,
                   idealWidth: 200.0,
                   maxWidth: 200.0)
        }
    }
        
    var textfield: some View {
        WithViewStore(store) { viewStore in
            TextField(
                "Search",
                text: viewStore.binding(
                    get: \.search,
                    send: ThemeAction.searchEntry))
                .padding(.leading)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    var roundCancelButton: some View {
        WithViewStore(store) { viewStore in
            HStack {
                Spacer()
                Button(action: {
                        viewStore.send(.clearSearch)
                        viewStore.send(.toggleShowingExpandedSearchBar)}) {
                    Image(systemName: "multiply.circle.fill")
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.gray)
            }
            .padding(.horizontal, 6)
        }
    }
}


struct SearchbarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchbarView(store: ThemeState.defaultStore)
    }
}
