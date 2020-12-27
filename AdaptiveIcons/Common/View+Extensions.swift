//
//  View+Extensions.swift
//  AdaptiveIcons
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

extension View {
    func clipShape(_ iconShape: IconShape?) -> some View {
        switch iconShape {
        
        case .roundedRectangle:
            return AnyView(self.clipShape(RoundedRectangle(cornerRadius: 10)))
            
        case .circle:
            return AnyView(self.clipShape(Circle()))
            
        default:
            return AnyView(self)
        }
    }
}


