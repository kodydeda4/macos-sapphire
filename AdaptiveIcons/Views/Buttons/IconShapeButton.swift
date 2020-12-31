//
//  IconShapeButton.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/31/20.
//

import SwiftUI
import ComposableArchitecture

struct IconShapeButton: View {
    let store: Store<AppState, AppAction>
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
        IconShapeButton(
            store: defaultStore,
            iconShape: .roundedRectangle,
            action: {}
        )
    }
}
