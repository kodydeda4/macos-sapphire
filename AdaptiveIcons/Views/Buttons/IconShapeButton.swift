//
//  IconShapeButton.swift
//  AdaptiveIcons
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

struct IconShapeButton: View {
    let store: Store<ThemeDetailState, ThemeDetailAction>
    var iconShape: IconShape
    var action: () -> Void
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Button(action: action) {
                Image(systemName: iconShape.rawValue)
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(
                        viewStore.selectedIconShape == iconShape
                            ? .accentColor
                            : .gray
                    )
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct IconShapeButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ForEach(IconShape.allCases, id: \.self) { iconShape in
                IconShapeButton(
                    store: ThemeDetailState.defaultStore,
                    iconShape: iconShape,
                    action: {}
                )
            }
        }
        .padding()
    }
}
