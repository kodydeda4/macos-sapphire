//
//  IconPack.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/21/20.
//

import Foundation
import SwiftUI

struct IconPackModel: Identifiable {
    let id = UUID()
    let imageName: String
    let name: String
    let textblock: String
}

let iconPacks = [
    IconPackModel(
        imageName: "square.grid.3x3",
        name: "Default",
        textblock: "Handmade icons from ....... and ..... and even ....."
    ),
    IconPackModel(
        imageName: "folder",
        name: "My Theme",
        textblock: "Handmade icons from ....... and ..... and even ....."
    ),
]

