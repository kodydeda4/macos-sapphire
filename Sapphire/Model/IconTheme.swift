//
//  IconTheme.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 1/8/21.
//

import SwiftUI

struct IconTheme: Identifiable, Hashable {
    let id = UUID()
    var backgroundColor: Color = .white
    var shape: IconShape = .transparent
    var iconShadow: Bool = false
    var shapeShadow: Bool = false
}
