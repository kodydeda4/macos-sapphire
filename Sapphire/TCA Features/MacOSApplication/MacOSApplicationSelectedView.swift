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
                    Button(action: { viewStore.send(.toggleSelected) }) {
                    FetchImageView(url: viewStore.iconURL)
                        .padding()
                        .frame(width: 125, height: 125)
                    }
                    .buttonStyle(PlainButtonStyle())
            }
            
            Text(viewStore.name)
                .font(.title)
                .bold()
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(height: 50)
                
                Button(viewStore.modified ? "Remove Icon" : "Create Icon") {
                    viewStore.send(.modifyIconButtonTapped)
                }
                
                Button("Blue") {
                    viewStore.send(.updateColor("82d7f8"))
                    print("update color to 82d7f8 for \(viewStore.name)")
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

