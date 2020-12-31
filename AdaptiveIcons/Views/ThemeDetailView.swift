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
                
                if viewStore.icons.filter(\.selected).count == 0 {
                    Text("No Selection")
                        .font(.title)
                        .foregroundColor(Color(NSColor.placeholderTextColor))
                    
                } else {
                    
                    if viewStore.icons.filter(\.selected).count > 1 {
                        IconDetailView(store: store, iconImage: Image(systemName: "scribble.variable"), iconText: "Preview")
                    } else {
                        IconDetailView(store: store, iconImage: Image(nsImage: viewStore.icons.filter(\.selected).first!.appIcon), iconText: viewStore.icons.filter(\.selected).first!.name)
                    }
                    
                    Divider()
                    VStack {
                        IconShapeSetterButtons(viewStore)
                        Divider()
                        BackgroundColorSettorButttons(viewStore)
                        Divider()
                        ShadowToggles(viewStore)
                        Spacer()
                        ApplyButtons(viewStore)
                    }
                    Spacer()
                }
            }
            .padding()
        }
    }
    
    private func IconShapeSetterButtons(_ viewStore: ViewStore<AppState, AppAction>) -> AnyView {
        AnyView(HStack {
            SetIconShapeButton(viewStore, iconShape: .roundedRectangle, systemName: "app.fill")
            SetIconShapeButton(viewStore, iconShape: .circle, systemName: "circle.fill")
            SetIconShapeButton(viewStore, iconShape: .none, systemName: "circle.dashed")
        })
    }
    
    private func BackgroundColorSettorButttons(_ viewStore: ViewStore<AppState, AppAction>) -> AnyView {
        AnyView(HStack {
            ForEach([Color
                        .blue, .purple, .pink, .red, .orange, .yellow, .green, .gray, .black, .white
            ], id: \.self) { color in
                SetBackgroundColorButton(viewStore, color: color)
            }
        })
    }
    
    private func ShadowToggles(_ viewStore: ViewStore<AppState, AppAction>) -> AnyView {
        AnyView(
            VStack(alignment: .leading) {
                Toggle(isOn: viewStore.binding(
                        get: \.iconShadow,
                        send: AppAction.toggleIconShadow)) {
                    Text("Icon Shadow")
                }
                Toggle(isOn: viewStore.binding(
                        get: \.shapeShadow,
                        send: AppAction.toggleShapeShadow)) {
                    Text("Background Shadow")
                }
            })
    }
    
    private func ApplyButtons(_ viewStore: ViewStore<AppState, AppAction>) -> AnyView {
        AnyView(HStack {
            Button("Reset",
                   action: { viewStore.send(.removeChanges) })
                .buttonStyle(PlainButtonStyle())
                .padding(7)
                .background(Color.gray)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            
            Button("Apply Changes",
                   action: { viewStore.send(.applyChanges) })
                .buttonStyle(PlainButtonStyle())
                .padding(7)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        })
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
                    .foregroundColor(
                        viewStore.selectedIconShape == iconShape
                            ? .accentColor
                            : .gray
                    )
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(PlainButtonStyle())
        )
    }
    
    private func SetBackgroundColorButton(_ viewStore: ViewStore<AppState, AppAction>, color: Color) -> AnyView {
        AnyView(
            Button(action: { viewStore.send(.setSelectedBackgroundColor(color)) }) {
                ZStack {
                    Circle()
                        .foregroundColor(color)
                        .frame(width: 15, height: 15)
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundColor(
                            Color.white.opacity(
                                viewStore.selectedBackgroundColor == color
                                    ? 1
                                    : 0
                            ))
                        .shadow(
                            color: Color.black.opacity(0.6),
                            radius: 2
                        )
                }
            }
            
            .buttonStyle(BorderlessButtonStyle())
        )
    }
}


struct ThemeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeDetailView(store: defaultStore)
    }
}





