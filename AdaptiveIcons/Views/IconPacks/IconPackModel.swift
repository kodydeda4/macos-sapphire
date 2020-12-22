//
//  IconPackModel.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/21/20.
//

import Foundation
import SwiftUI

struct IconPackModel: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    var icons: [IconView]
}

let iconPacks = [
    IconPackModel(
        name: "Default",
        description: "The default icons.",
        icons: apps.map { IconView(app: $0, theme: IconThemeModel(), iconPack: nil) }
    ),
]
