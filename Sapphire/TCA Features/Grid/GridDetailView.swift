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
            VStack {
                if viewStore.macOSApplications.filter(\.selected).isEmpty {
                    Text("No Selection")
                        .font(.title)
                        .foregroundColor(Color(.disabledControlTextColor))
                    
                } else if viewStore.selectedApp != nil {
                    MacOSApplicationSelectedView(
                        application: viewStore.selectedApp!
                    )
                    
                    ColorSelectorView(selection: viewStore.binding(get: \.selectedColor, send: Grid.Action.updateSelectedColor))
                        .padding(.bottom)
                    
                    Button("Apply Changes") {
                        viewStore.send(.createPasswordRequiredAlert)
                    }

                    
                } else {
                    Text("Multiple Selections")
                        .font(.title)
                        .foregroundColor(Color(.disabledControlTextColor))
                    Button("Create Icon") {
                        viewStore.send(.modifySystemApplications)
                    }
                }
                Spacer()
            }
            .padding()
            .fixedSize()
        }
    }
}

// MARK:- SwiftUI_Previews
struct GridDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GridDetailView(store: Grid.defaultStore)
    }
}
