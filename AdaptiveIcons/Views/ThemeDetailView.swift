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
                    IconDetailView(
                        store: store,
                        iconFrameWidth: 100,
                        iconFrameHeight: 100,
                        iconImage: viewStore.iconDetailViewImage,
                        iconText: viewStore.iconDetailViewText
                    )
                    Divider()
                    VStack {
                        HStack {
                            ForEach(IconShape.allCases, id: \.self) { iconShape in
                                IconButtonShape(
                                    store: store,
                                    iconShape: iconShape,
                                    action: { viewStore.send(.setSelectedIconShape(iconShape)) })
                            }
                        }
                        
                        Divider()
                        HStack {
                            ForEach(viewStore.iconBackgroundColors, id: \.self) { color in
                                SetBackgroundColorButton(
                                    color: color,
                                    action: { viewStore.send(.setSelectedBackgroundColor(color)) }
                                )
                            }
                        }
                        Divider()
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
                        }
                        Spacer()
                        HStack {
                            Button("Reset", action: { viewStore.send(.removeChanges) })
                                .buttonStyle(RoundedRectangleButtonStyle())
                            
                            Button("Apply Changes", action: { viewStore.send(.applyChanges) })
                                .buttonStyle(RoundedRectangleButtonStyle())
                        }
                    }
                    Spacer()
                }
            }
            .padding()
        }
    }
    
    private func IconShapeButton(
        iconShape: IconShape?,
        systemName: String,
        action: @escaping () -> Void) -> AnyView {
        
        return AnyView(
            WithViewStore(store) { viewStore in
                Button(action: action) {
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
            }
        )
    }

    private func SetBackgroundColorButton(
        color: Color,
        action: @escaping () -> Void) -> AnyView {
        
        AnyView(
            WithViewStore(store) { viewStore in
                Button(action: action) {
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
        })
    }
}


struct RoundedRectangleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .buttonStyle(PlainButtonStyle())
            .padding(7)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

struct IconButtonShape: View {
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





struct ThemeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeDetailView(store: defaultStore)
    }
}
