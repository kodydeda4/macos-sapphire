//
//  ColorSelectorView.swift
//  Sapphire
//
//  Created by Kody Deda on 12/31/20.
//

import SwiftUI
import ComposableArchitecture

struct ColorSelectorView: View {
    @Binding var selection: Color
    let colors: [Color] =
        [.blue, .purple, .pink, .red, .orange, .yellow, .green, .gray, .black, .white]
        
    var body: some View {
        HStack {
            ForEach(colors, id: \.self) { color in
                Button(action: { selection = color }) {
                    ZStack {
                        Circle()
                            .foregroundColor(color)
                            .frame(width: 15, height: 15)
                        Circle()
                            .frame(width: 6, height: 6)
                            .foregroundColor(Color.white.opacity(selection == color ? 1 : 0))
                            .shadow(color: Color.black.opacity(0.6), radius: 2)
                    }
                }.buttonStyle(BorderlessButtonStyle())
            
            }
        }
    }
}



struct ColorSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSelectorView(selection: .constant(.white))
    }
}
