//
//  GridView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import SwiftUI
import ComposableArchitecture

struct GridView: View {
    let store: Store<Grid.State, Grid.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                LazyVGrid(columns: [GridItem](repeating: .init(.fixed(90)), count: 6)) {
                    ForEachStore(store.scope(
                        state: { $0.macOSApplications },
                        action: Grid.Action.macOSApplication(index:action:)
                    ), content: MacOSApplicationView.init)
                }
                .frame(width: 600)
                .padding()
            }
            .toolbar {
                ToolbarItem {
                    Spacer()
                }


                ToolbarItem {
                    Button("Refresh Cache") {
                        viewStore.send(.resetCacheButtonTapped)
                    }
                    .help("Refresh system cache")
                }
                ToolbarItem {
                    Button("Select Modified") {
                        viewStore.send(.selectModifiedButtonTapped)
                    }
                    .help("Select All")
                }
                ToolbarItem {
                    Button("Select All") {
                        viewStore.send(.selectAllButtonTapped)
                    }
                    .help("Select All")
                }
            }
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(store: Grid.defaultStore)
    }
}
