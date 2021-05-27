//
//  GridDetailView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import SwiftUI
import ComposableArchitecture

struct GridDetailView: View {
    let store: Store<Grid.State, Grid.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            
            if viewStore.macOSApplications.filter(\.selected).isEmpty {
                Text("No Selection")
                    .font(.title)
                    .foregroundColor(Color(.disabledControlTextColor))
                
            } else {
                VStack {
                    LazyVGrid(columns: [GridItem](repeating: .init(.flexible()), count: 3)) {
                        ForEachStore(store.scope(
                            state: { $0.macOSApplications.filter(\.selected) },
                            action: Grid.Action.macOSApplication(index:action:)
                        )) {
                            SelectedMacOSApplicationView.init(
                                store: $0,
                                color: .constant(viewStore.selectedColor)
                            )
                        }
                    }
                    
                    Divider()
                    
                    ColorSelectorView(
                        selection: viewStore.binding(
                            get: \.selectedColor,
                            send: Grid.Action.updateSelectedColor
                        )
                    )
                    .padding(4)
                    
                    Divider()
                    
                    HStack {
                        Button("Reset") { viewStore.send(.createResetIconsAlert) }
                        Button("Apply") { viewStore.send(.createSetIconsAlert) }
                    }
                    .padding()
                }
                .padding()
            }
        }
    }
}



// MARK:- SwiftUI_Previews
struct GridDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GridDetailView(store: Grid.defaultStore)
    }
}
