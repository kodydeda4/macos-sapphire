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
                    GroupBox {
                        GridSelectionView(store: store)
                    }
                    
                    GroupBox {
                        ColorSelectorView(
                            selection: viewStore.binding(
                                get: \.selectedColor,
                                send: Grid.Action.updateSelectedColor
                            )
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical)
                }
                .frame(width: 350)
                .padding()
                .toolbar {
                    ToolbarItem {
                        Button("Reset") { viewStore.send(.createResetIconsAlert) }
                    }
                    ToolbarItem {
                        Button("Apply") { viewStore.send(.createSetIconsAlert) }
                    }
                }
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
