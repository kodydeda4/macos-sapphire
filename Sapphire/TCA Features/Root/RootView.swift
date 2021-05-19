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
            GridView(store: store)
            
        }
    }
}







struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: Root.defaultStore)
    }
}
