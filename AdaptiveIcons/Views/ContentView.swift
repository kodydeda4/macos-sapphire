//
//  ContentView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/15/20.
//

import SwiftUI
import Grid
import ComposableArchitecture

// MARK:- ContentView

struct ContentView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        NavigationView {
            List {}
            ThemePrimaryView(store: store)
            ThemeDetailView(store: store)
        }
        .frame(width: 1920/2, height: 1080/2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: mockupStore)
    }
}
