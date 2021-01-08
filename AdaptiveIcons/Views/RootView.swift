//
//  RootView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 1/8/21.
//

import SwiftUI
import ComposableArchitecture


struct RootView: View {
    let store: Store<RootState, RootAction>
    
    var body: some View {
        NavigationView {
            SidebarView(store: store)
            ThemeView(store: ThemeState.defaultStore)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: RootState.defaultStore)
    }
}
