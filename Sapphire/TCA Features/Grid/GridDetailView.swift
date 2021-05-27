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
            switch viewStore.macOSApplications.filter(\.selected).count {
            
            case 0:
                Text("No Selection")
                    .font(.title)
                    .foregroundColor(Color(.disabledControlTextColor))

            default:
                VStack {
                    GridSelectionView(store: store)
                    
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
