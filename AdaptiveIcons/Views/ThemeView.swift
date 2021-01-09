//
//  ContentView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/15/20.
//

import SwiftUI
import Grid
import ComposableArchitecture

struct ThemeView: View {
    let store: Store<ThemeState, ThemeAction>
    
    var body: some View {
        NavigationView {
            SidebarView()
            ThemePrimaryView(store: store)
            ThemeDetailView(
                store: store.scope(
                    state: \.selectedIconState,
                    action: ThemeAction.selectedIconAction))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView(store: ThemeState.defaultStore)
    }
}
