//
//  View+Extensions.swift
//  Sapphire
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI

extension Image {
    /// Creates a SwiftUI image from contentsOfFile.
    public init(_ url: URL) {
        self.init(nsImage: NSImage(contentsOfFile: url.path) ?? NSImage.init())
    }
}

