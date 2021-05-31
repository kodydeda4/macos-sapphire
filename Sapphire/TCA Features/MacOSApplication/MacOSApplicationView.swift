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
                    ZStack {
                        Image(systemName: "app.fill")
                            .resizable()
                            .scaledToFill()
                            .padding(5)
                            .foregroundColor(Color(fromHex: viewStore.colorHex))
                            .opacity(viewStore.modified ? 1 : 0)
                        
                        FetchImageView(url: viewStore.iconURL)
                            .padding(viewStore.modified ? 10 : 0)
                            
                    }
                    .shadow(color: Color.black.opacity(viewStore.modified ? 0.2 : 0), radius: 0.5, y: 0.5)
                    
                    Text(viewStore.name)
                        .font(.caption)
                        .lineLimit(1)
                }
                .padding()
                .background(
                    GroupBox { Color.clear }
                        .opacity(viewStore.selected ? 0.8 : 0.0000001)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct MacOSApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        MacOSApplicationView(store: MacOSApplication.defaultStore)
    }
}
