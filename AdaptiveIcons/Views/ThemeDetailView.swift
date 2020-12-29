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
                
                VStack(spacing: 3) {
                    Image(systemName: viewStore.selectedIconShape?.rawValue ?? "circle.dashed")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(viewStore.selectedBackgroundColor)
                        .shadow(color: Color.black.opacity(viewStore.selectedShapeShadow ? 0.25 : 0), radius: 1.6, y: 2.0)
                        .frame(width: 100, height: 100)
                        
                    Text("Preview")
                        .font(.system(size: 11, weight: .regular))
                        .multilineTextAlignment(.center)
                        .padding(3)
                }
                
                Divider()
                    VStack {
                    HStack {
                        SetIconShapeButton(viewStore, iconShape: .roundedRectangle, systemName: "square.fill")
                        SetIconShapeButton(viewStore, iconShape: .circle, systemName: "circle.fill")
                        SetIconShapeButton(viewStore, iconShape: .none, systemName: "circle.dashed")
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
                
            }
            .padding()
        }
    }
    
    private func SetIconShapeButton(
        _ viewStore: ViewStore<AppState, AppAction>,
        iconShape: IconShape?,
        systemName: String) -> AnyView {
         
        return AnyView(
            Button(action: { viewStore.send(.setSelectedIconShape(iconShape)) }) {
                
            Image(systemName: systemName)
                .resizable()
                .scaledToFill()
                .foregroundColor(viewStore.selectedIconShape == iconShape ? .accentColor : .gray)
                .frame(width: 35, height: 35)
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
