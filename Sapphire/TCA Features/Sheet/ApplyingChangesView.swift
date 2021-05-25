//
//  ApplyingChangesView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/25/21.
//

import SwiftUI

struct ApplyingChanges: View {
    @State var opacity = true
    
    var body: some View {
        VStack {
            Image("SapphireIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 90)
            
//            Text("Applying Changes")
//                .font(.title2)
//                .fontWeight(.medium)
//                .padding()
        }
        .padding(30)
        .opacity(opacity ? 1 : 0)
        .animation(Animation.easeInOut(duration: 1.25).repeatForever(), value: opacity)
        .onAppear { opacity.toggle() }
    }
}

struct ApplyingChanges_Previews: PreviewProvider {
    static var previews: some View {
        ApplyingChanges()
    }
}
