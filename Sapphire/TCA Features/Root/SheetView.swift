//
//  SheetView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import SwiftUI
import ComposableArchitecture

struct SheetView: View {
    let store: Store<Root.State, Root.Action>
    @State var opacity = true
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Image("SapphireIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90)

                Text("Applying Changes")
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding()
            }
            .padding(30)
            .opacity(opacity ? 1 : 0)
            .animation(Animation.easeInOut(duration: 1).repeatForever(), value: opacity)
            .onAppear { opacity.toggle() }
        }
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(store: Root.defaultStore)
    }
}
