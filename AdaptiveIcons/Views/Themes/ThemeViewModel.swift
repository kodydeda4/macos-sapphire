//
//  ThemeViewModel.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/22/20.
//

import SwiftUI

struct ThemeViewModel: Identifiable {
    var id = UUID()
    var name: String
    var theme: IconThemeModel
    
    var icons: [IconView] {
        apps.map{ IconView(app: $0, theme: theme, iconPack: iconPacks[0]) }
    }
}

let themes: [ThemeViewModel] = [
    ThemeViewModel(
        name: "My Theme 1",
        theme: IconThemeModel()
    ),
    
    ThemeViewModel(
        name: "My Theme 2",
        theme: IconThemeModel(
            iconShadow: 0.4,
            iconShape: .roundedRectangle,
            iconShapeColor: .white,
            iconShapeShadow: 0
       )
    )
]
