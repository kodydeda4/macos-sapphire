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
            VStack {
                if viewStore.macOSApplications.filter(\.selected).isEmpty {
                    Text("No Selection")
                        .font(.title)
                        .foregroundColor(Color(.disabledControlTextColor))
                    
                } else if viewStore.macOSApplications.filter(\.selected).count == 1 {
                    ForEachStore(store.scope(
                        state: { $0.macOSApplications.filter(\.selected) },
                        action: Root.Action.macOSApplication(index:action:)
                    ), content: MacOSApplicationSelectedView.init(store:))
                    
                } else {
                    Text("Multiple Selections")
                        .font(.title)
                        .foregroundColor(Color(.disabledControlTextColor))
                    Button("Create Icon") {
                        viewStore.send(.modifyLocalIcons)
                    }
                }
                Spacer()
            }
            .fixedSize()
            //            .toolbar {
            //                ToolbarItem {
            //                    Button<Image>("checkmark.circle") {
            //                        viewStore.send(.applyChanges)
            //                    }
            //                    .help("Apply Changes")
            //                }
            //            }
        }
    }
}

// MARK:- SwiftUI_Previews
struct GridDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GridDetailView(store: Root.defaultStore)
    }
}
