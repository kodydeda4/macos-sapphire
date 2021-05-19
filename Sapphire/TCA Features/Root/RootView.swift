//
//  RootView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/18/21.
//

import SwiftUI
import ComposableArchitecture
import Grid

struct RootView: View {
    let store: Store<Root.State, Root.Action>
    
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                LazyVGrid(columns: [GridItem](repeating: .init(.fixed(90)), count: 8)) {
                    ForEachStore(store.scope(
                        state: \.macOSApplications,
                        action: Root.Action.macOSApplication(index:action:)
                    ), content: MacOSApplicationView.init(store:))
                }
                .frame(width: 780)
                .padding()
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: Root.defaultStore)
    }
}
