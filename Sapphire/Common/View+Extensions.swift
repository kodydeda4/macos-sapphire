//
//  View+Extensions.swift
//  Sapphire
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI

extension Image {
    public init?(contentsOfFile: String) {
        guard let image = NSImage(contentsOfFile: contentsOfFile)
        else { return nil }
        self.init(nsImage: image)
    }
}
