//
//  ThemeDetailView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI
import Combine
import ComposableArchitecture
import Grid

struct ThemeDetailView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .center) {
                Text("Customize")
                
                Divider()
                HStack {
                    IconShapeButton(viewStore: viewStore, iconShape: .roundedRectangle, systemName: "square.fill")
                    IconShapeButton(viewStore: viewStore, iconShape: .circle, systemName: "circle.fill")
                    IconShapeButton(viewStore: viewStore, iconShape: .none, systemName: "circle.dashed")
                }
                Divider()
                
                ColorPicker("Color",
                    selection: viewStore.binding(
                        get: \.selectedBackgroundColor,
                        send: AppAction.setSelectedBackgroundColor))

                Toggle(isOn: viewStore.binding(
                        get: \.selectedIconShadow,
                        send: AppAction.setSelectedIconShadow)) {
                    Text("Icon Shadow")
                }
                
                Toggle(isOn: viewStore.binding(
                        get: \.selectedShapeShadow,
                        send: AppAction.setSelectedShapeShadow)) {
                    Text("Shape Shadow")
                }
                
                Button("Remove Changes",
                    action: { viewStore.send(.removeChanges) })
                
                Button("Apply Changes",
                       action: { viewStore.send(.applyChanges) })
                
            }
            .padding()
        }
    }
    
    private func IconShapeButton(
        viewStore: ViewStore<AppState, AppAction>,
        iconShape: IconShape?,
        systemName: String) -> AnyView {
         
        return AnyView(
            Button(action: { viewStore.send(.setSelectedIconShape(iconShape)) }) {
                
            Image(systemName: systemName)
                .resizable()
                .scaledToFill()
                .foregroundColor(viewStore.selectedIconShape == iconShape ? .accentColor : .gray)
                .frame(width: 40, height: 40)
            }
            .buttonStyle(PlainButtonStyle())
        )
    }
}

struct ThemeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeDetailView(store: defaultStore)
    }
}
