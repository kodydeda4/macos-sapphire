//
//  Icon.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/21/20.
//

import SwiftUI


struct Icon: View {
    let app: CustomApp
    let theme: IconTheme
    
    enum Shape {
        case bigSur
        case circle
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            iconImage
                .background(theme.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: Color.black.opacity(0.2), radius: 1, y: 1)
            iconName
        }
        .frame(width: 100, height: 100)
    }
    
    var iconImage: some View {
        Image(contentsOfFile: app.defaultIconPath)?
            .resizable()
            .scaledToFill()
            .padding(4)
            .frame(width: 55, height: 55)
    }
    
    var iconName: some View {
        Text(app.name)
            .font(.system(size: 11, weight: .regular))
            .multilineTextAlignment(.center)
            .frame(width: 90, height: 30, alignment: .top)
    }
}

struct BasicViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        return content
    }
}


extension Image {
    public init?(contentsOfFile: String) {
        guard let image = NSImage(contentsOfFile: contentsOfFile)
            else { return nil }
        self.init(nsImage: image)
    }
}

struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        Icon(app: apps[0], theme: iconPacks[0].iconTheme)
    }
}
