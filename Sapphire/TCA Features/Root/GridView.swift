//
//  GridView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import SwiftUI
import ComposableArchitecture

struct GridView: View {
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

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(store: Root.defaultStore)
    }
}
