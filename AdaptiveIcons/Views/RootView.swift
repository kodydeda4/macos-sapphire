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
            SidebarView(store: ThemeManager.defaultStore)
                .frame(minWidth: 180, idealWidth: 250, maxWidth: 300)
            VStack {
                Text("Welcome Page")
                    .font(.largeTitle)
            }
        }
    }
}


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: RootState.defaultStore)
    }
}
