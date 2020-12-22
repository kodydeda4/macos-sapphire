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
    var shapeColor: Color
    var shapeShadow: Double
    var iconShadow: Double

    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            ZStack {
                iconShape
                
                if shape == .roundedRectangle {
                    iconImage
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                
                if shape == .circle {
                    iconImage
                        .clipShape(Circle())
                }
                

            }
            .frame(width: 55, height: 55)
            iconLabel
        }
        .frame(width: 100, height: 100)
    }

    var iconShape: some View {
        getShape(shape: shape)
            .foregroundColor(shapeColor)
            .shadow(color: Color.black.opacity(shapeShadow), radius: 1, y: 1)
    }
    
    var iconImage: some View {
        Image(contentsOfFile: app.defaultIconPath)?
            .resizable()
            .scaledToFill()
            .padding(4)
            .shadow(color: Color.black.opacity(iconShadow), radius: 1, y: 1)
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
        IconView(app: apps[0], shape: .roundedRectangle, shapeColor: .white, shapeShadow: 0.2, iconShadow: 0.2)
    }
}



