//
//  IconView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/22/20.
//

import SwiftUI

struct IconView: View {
    let app: AppModel
    
    enum IconShape: String, CaseIterable {
        case roundedRectangle = "Rounded Rectangle"
        case circle = "Circle"
    }
    
    var shape: IconShape
    var bgColor: Color
    

    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            ZStack {
                getShape(shape: shape)
                    .foregroundColor(bgColor)
                iconImage
            }
            .shadow(color: Color.black.opacity(0.2), radius: 1, y: 1)
            .frame(width: 55, height: 55)
            iconLabel
        }
        .frame(width: 100, height: 100)
    }

    
    var iconImage: some View {
        Image(contentsOfFile: app.defaultIconPath)?
            .resizable()
            .scaledToFill()
            .padding(4)

    }
    
    var iconLabel: some View {
        Text(app.name)
            .font(.system(size: 11, weight: .regular))
            .multilineTextAlignment(.center)
            .frame(width: 90, height: 30, alignment: .top)
    }


    func getShape(shape: IconShape) -> some View {
        switch shape {
        case .roundedRectangle:
            return AnyView(RoundedRectangle(cornerRadius: 10))
        case .circle:
            return AnyView(Circle())
        }
    }
}

extension Image {
    public init?(contentsOfFile: String) {
        guard let image = NSImage(contentsOfFile: contentsOfFile)
            else { return nil }
        self.init(nsImage: image)
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView(app: apps[0], shape: .roundedRectangle, bgColor: .white)
    }
}



