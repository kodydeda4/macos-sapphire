//
//  RootView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/18/21.
//

import SwiftUI
import ComposableArchitecture

struct GridView: View {
    let store: Store<Grid.State, Grid.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                GridMainView(store: store)
                GridDetailView(store: store)
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            .alert(store.scope(state: \.alert), dismiss: .dismissPasswordRequiredAlert)
            .sheet(isPresented: .constant(viewStore.inFlight)) {
                ApplyingChangesView(store: store)
            }
        }
    }
}

// MARK:- SwiftUI_Previews
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(store: Grid.defaultStore)
    }
}

