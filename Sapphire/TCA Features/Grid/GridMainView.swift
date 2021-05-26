//
//  GridView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import SwiftUI
import ComposableArchitecture

struct GridMainView: View {
    let store: Store<Grid.State, Grid.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                LazyVGrid(columns: [GridItem](repeating: .init(.fixed(90)), count: 6)) {
                    ForEachStore(store.scope(
                        state: \.macOSApplications,
                        action: Grid.Action.macOSApplication(index:action:)
                    ), content: MacOSApplicationView.init)
                }
                .frame(width: 600)
                .padding()
            }
            .onAppear { viewStore.send(.onAppear) }
            .toolbar {
                ToolbarItem {
                    Spacer()
                }
                ToolbarItem {
                    Button("Select Modified") {
                        viewStore.send(.selectModifiedButtonTapped)
                    }
                    .help("Select All")
                }
                ToolbarItem {
                    Button("Set Color to Blue") {
                        viewStore.send(.updateSelectedColor(.blue))
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
        GridMainView(store: Grid.defaultStore)
    }
}
