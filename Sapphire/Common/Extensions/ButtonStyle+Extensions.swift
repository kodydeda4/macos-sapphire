//
//  ButtonStyle+Extensions.swift
//  Sapphire
//
//  Created by Kody Deda on 5/25/21.
//

import SwiftUI

struct RoundedRectangleButtonStyle: ButtonStyle {
    var color: Color = Color.primary
    
    func makeBody(configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 40)
            .foregroundColor(color)
            .overlay(configuration.label.foregroundColor(color == Color.primary ? .secondary : .white))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct ButtonStyle_Extensions_Previews: PreviewProvider {
    static var previews: some View {
        
        VStack {
            Button("Tap Me") {}
                .buttonStyle(RoundedRectangleButtonStyle())

            Button("Tap Me") {}
                .buttonStyle(RoundedRectangleButtonStyle(color: .accentColor))
            
        }
        .padding()
    }
}
