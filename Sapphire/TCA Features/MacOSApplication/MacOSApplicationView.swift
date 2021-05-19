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
    
    //@State var hovering = false
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Button(action: { viewStore.send(.toggleSelected) }) {
                VStack {
                    ImageView(url: viewStore.icon)
                        .padding(.bottom, 3)
                    
                    Text(viewStore.name)
                        .font(.caption)
                        .lineLimit(1)
                }
//                .background(Color.gray.opacity(hovering ? 0.1 : 0))
            }
            //.onHover { _ in hovering.toggle() }
            .buttonStyle(PlainButtonStyle())
            .padding()
            .border(Color.gray.opacity(viewStore.selected ? 1 : 0))
        }
    }
}

struct MacOSApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        MacOSApplicationView(store: MacOSApplication.defaultStore)
    }
}
