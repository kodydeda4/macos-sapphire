//
//  RootView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/18/21.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: Store<Grid.State, Grid.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                GridView(store: store)
                GridDetailView(store: store)
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            .alert(store.scope(state: \.alert), dismiss: .dismissResetAlert)
            .sheet(isPresented: viewStore.binding(get: \.sheet, send: .toggleSheetView)) {
                SheetView(store: store)
            }
        }
    }
}

// MARK:- SwiftUI_Previews
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: Grid.defaultStore)
    }
}

