//
//  IconViewModel.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/22/20.
//

import SwiftUI

struct IconThemeModel {
    var iconShadow: Double?
    var iconShape: IconViewModel.IconShape?
    var iconShapeColor: Color?
    var iconShapeShadow: Double?
}

struct IconViewModel: View {
    enum IconShape: String, CaseIterable {
        case roundedRectangle = "Rounded Rectangle"
        case circle = "Circle"
    }
    
    var name: String
    var image: Image?
    var theme: IconThemeModel?

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            image?
                .resizable()
                .scaledToFill()
                .padding(4)
                .shadow(color: Color.black.opacity(theme?.iconShadow ?? 0), radius: 1, y: 1)
                .background(theme?.iconShapeColor)
                .clipShape(theme?.iconShape)
                .shadow(color: Color.black.opacity(theme?.iconShapeShadow ?? 0), radius: 1, y: 1)
                .frame(width: 55, height: 55)
            
            Text(name)
                .font(.system(size: 11, weight: .regular))
                .multilineTextAlignment(.center)
                .frame(width: 90, height: 30, alignment: .top)
        }
        .frame(width: 100, height: 100)
    }
}


struct IconViewModel_Previews: PreviewProvider {
    static var previews: some View {
        IconViewModel(
            name: "Model",
            image: Image(systemName: "cube"),
            theme: IconThemeModel()
        )
    }
}
