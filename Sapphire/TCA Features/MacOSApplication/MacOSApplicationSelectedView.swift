//
//  MacOSApplicationSelectedView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/20/21.
//

import SwiftUI
import ComposableArchitecture

struct MacOSApplicationSelectedView: View {
    let store: Store<MacOSApplication.State, MacOSApplication.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                GroupBox {
                    IconView(store: store)
                        .padding()
                        .frame(width: 125, height: 125)
                }
            
            Text(viewStore.name)
                .font(.title)
                .bold()
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(height: 50)
                
                ColorSelectorView(
                    selection: viewStore.binding(
                        get: \.color.color,
                        send: MacOSApplication.Action.updateColor))
                
                Button(viewStore.customized ? "Remove Icon" : "Create Icon") {
                    viewStore.send(.modifyIconButtonTapped)
                }
            }
        }
    }
}

// MARK:- SwiftUI_Previews
struct MacOSApplicationSelectedView_Previews: PreviewProvider {
    static var previews: some View {
        MacOSApplicationSelectedView(store: MacOSApplication.defaultStore)
    }
}

