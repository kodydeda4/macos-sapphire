//
//  IconView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/25/20.
//

import SwiftUI
import Combine
import ComposableArchitecture
import Grid

enum IconShape: String, CaseIterable {
    case roundedRectangle = "app.fill"
    case circle = "circle.fill"
}

struct IconView: View {
    let store: Store<AppState, AppAction>
    var icon: Icon
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Button(action: { viewStore.send(.toggleSelected(icon)) }) {
                VStack(alignment: .center, spacing: 3) {
                    ZStack {
                        // Shape
                        Image(systemName: icon.shape?.rawValue ?? "circle")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(icon.shape != nil ? icon.backgroundColor : .clear)
                            .padding(icon.shape != nil ? 5 : 0)
                            .shadow(color: Color.black.opacity(icon.shapeShadow ? 0.25 : 0), radius: 1.6, y: 2.0)

                        
                        // Icon
                        Image(nsImage: icon.appIcon)
                            .resizable()
                            .scaledToFill()
                            .padding(icon.shape != nil ? 8 : 0)
                            .shadow(color: Color.black.opacity(icon.iconShadow ? 0.25 : 0), radius: 1.6, y: 2.0)
                    }
                    .frame(width: 60, height: 60)

                    // Icon Text
                    Text(icon.name)
                        .font(.system(size: 11, weight: .regular))
                        .multilineTextAlignment(.center)
                        .padding(3)
                    
                }
                .padding(5)
                .frame(width: 100, height: 100, alignment: .top)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(lineWidth: 1)
                    .foregroundColor(selectionColor(viewStore)).opacity(0.5))
            
            .buttonStyle(BorderlessButtonStyle())
            .onAppear { iddlog("body \(icon.name)") }
        }
    }
    
    private func selectionColor(_ viewStore: ViewStore<AppState, AppAction>) -> Color {
        Color.secondary.opacity(isSelected(viewStore) ? 1 : 0)
    }
    
    private func isSelected(_ viewStore: ViewStore<AppState, AppAction>) -> Bool {
        viewStore.icons.filter(\.selected).contains(icon)
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        var icon = Icon(path: "/Applications/Pages.app")
        
        icon.shape = .roundedRectangle
        return IconView(store: defaultStore, icon: icon)
    }
}
