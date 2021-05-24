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
                Text("inFlight: \(viewStore.inFlight.description)")
                    .foregroundColor(viewStore.inFlight ? .accentColor : .primary)
                
//                LazyVGrid(columns: [GridItem](repeating: .init(.fixed(90)), count: 6)) {
//                    ForEachStore(store.scope(
//                        state: { $0.macOSApplications },
//                        action: Grid.Action.macOSApplication(index:action:)
//                    ), content: MacOSApplicationView.init(store:))
//                }
                
                ScrollView {
                    ForEachStore(store.scope(
                        state: { $0.macOSApplications },
                        action: Grid.Action.macOSApplication(index:action:)
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
                    .help("Select All")
                }
                ToolbarItem {
                    Button("Select Modified") {
                        viewStore.send(.selectModifiedButtonTapped)
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
