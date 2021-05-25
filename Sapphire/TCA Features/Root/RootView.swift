//
//  RootView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/18/21.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: Store<Root.State, Root.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                GridView(store: store.scope(state: \.grid, action: Root.Action.grid))
                GridDetailView(store: store.scope(state: \.grid, action: Root.Action.grid))
            }
            .onAppear { viewStore.send(.onAppear) }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            .sheet(isPresented: viewStore.binding(get: \.grid.sheet, send: .toggleSheetView)) {
                SheetView(store: store.scope(state: \.grid, action: Root.Action.grid))
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: Root.defaultStore)
    }
}




