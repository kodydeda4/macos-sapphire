//
//  IconShapeSelectorView.swift
//  Sapphire
//
//  Created by Kody Deda on 12/31/20.
//

import SwiftUI
import ComposableArchitecture

enum IconShape: String, CaseIterable {
    case roundedRectangle = "app.fill"
    case circle = "circle.fill"
    case transparent = "circle.dashed"
}

struct IconShapeSelectorView: View {
    @Binding var selection: IconShape
    
    var body: some View {
        HStack {
            ForEach(IconShape.allCases, id: \.self) { iconShape in
                Button(action: { selection = iconShape }) {
                    Image(systemName: iconShape.rawValue)
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(
                            selection == iconShape
                                ? .accentColor
                                : .gray
                        )
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}


struct IconShapeSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        IconShapeSelectorView(selection: .constant(.roundedRectangle))
    }
}
