//
//  MacOSApplicationView.swift
//  Sapphire
//
//  Created by Kody Deda on 12/25/20.
//

import SwiftUI
import ComposableArchitecture

struct MacOSApplicationView: View {
    let store: Store<MacOSApplication.State, MacOSApplication.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Button(action: { viewStore.send(.toggleSelected) }) {
                VStack {
                    IconView(store: store)
                    
                    Text(viewStore.name)
                        .font(.caption)
                        .lineLimit(1)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
            .background(
                GroupBox {
                    Color.clear
                }
                .opacity(viewStore.selected ? 0.8 : 0)
            )
        }
    }
}

struct MacOSApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        MacOSApplicationView(store: MacOSApplication.defaultStore)
    }
}
