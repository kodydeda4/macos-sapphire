//
//  IconPack.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/21/20.
//

import Foundation
import SwiftUI

struct IconPack: Identifiable {
    let id = UUID()
    let imageName: String
    let name: String
    let textblock: String
    let iconTheme: IconTheme
}

struct IconTheme {
    let backgroundColor: Color?
    let shape: Icon.Shape?
}

let iconPacks = [
    IconPack(
        imageName: "square.grid.3x3",
        name: "Default",
        textblock: "Handmade icons from ....... and ..... and even .....",
        
        iconTheme: IconTheme(
            backgroundColor: nil,
            shape: nil
        )
    ),
    IconPack(
        imageName: "square.grid.3x3",
        name: "Big Sur",
        textblock: "Handmade icons from ....... and ..... and even .....",
        
        iconTheme: IconTheme(
            backgroundColor: .white,
            shape: .bigSur
        )
    ),
]
