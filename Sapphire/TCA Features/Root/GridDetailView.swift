//
//  GridDetailView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import SwiftUI
import ComposableArchitecture

struct GridDetailView: View {
    let store: Store<Root.State, Root.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                if viewStore.selections.isEmpty {
                    Text("No Selection")
                        .font(.title2)
                        .foregroundColor(Color(.disabledControlTextColor))
                } else {
                    
                    ForEach(viewStore.selections, id: \.self) {
                        Text($0.name)
                            .foregroundColor(Color(.disabledControlTextColor))
                    }
                }
                
            }
            .fixedSize()
            .toolbar {
                ToolbarItem {
                    Button<Image>("checkmark.circle") {
                        viewStore.send(.applyChanges)
                    }
                    .help("Apply Changes")
                }
            }
        }
    }
}

// MARK:- SwiftUI_Previews
struct GridDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GridDetailView(store: Root.defaultStore)
    }
}
