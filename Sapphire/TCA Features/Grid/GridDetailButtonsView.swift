//
//  GridDetailButtonsView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/27/21.
//

import SwiftUI
import ComposableArchitecture

struct GridDetailButtonsView: View {
    let store: Store<Grid.State, Grid.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
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
        }
    }
}

struct GridDetailButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        GridDetailButtonsView(store: Grid.defaultStore)
    }
}
