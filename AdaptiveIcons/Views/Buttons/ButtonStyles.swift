//
//  ButtonViews.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/31/20.
//

import SwiftUI

struct RoundedRectangleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .buttonStyle(PlainButtonStyle())
            .padding(7)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

