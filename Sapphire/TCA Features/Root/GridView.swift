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
                LazyVGrid(columns: [GridItem](repeating: .init(.fixed(90)), count: 6)) {
                    ForEachStore(store.scope(
                        state: { $0.macOSApplications },
                        action: Root.Action.macOSApplication(index:action:)
                    ), content: MacOSApplicationView.init(store:))
                }
                //.frame(width: 600)
                .padding()
            }
            .toolbar {
                ToolbarItem {
                    Spacer()
                }
                ToolbarItem {
                    Button("Select All") {
                        viewStore.send(.selectAllButtonTapped)
                    }
                    .help("Apply Changes")
                }
            }
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(store: Root.defaultStore)
    }
}
