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

struct IconView: View {
    let store: Store<ThemeState, ThemeAction>
    var icon: Icon
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Button(action: { viewStore.send(.selectedIconAction(.toggleSelected(icon))) }) {
                VStack(alignment: .center, spacing: 3) {
                    ZStack {
                        shape
                        iconView
                    }
                    .frame(width: 60, height: 60)
                    iconText
                }
                .padding(5)
                .frame(width: 100, height: 100, alignment: .top)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(lineWidth: 1)
                    .foregroundColor(selectionColor(viewStore)).opacity(0.5)
                    
            )
            .buttonStyle(BorderlessButtonStyle())
            .onAppear { iddlog("body \(icon.name)") }
        }
    }
    
    var shape: some View {
        Image(systemName: icon.iconTheme.shape.rawValue)
            .resizable()
            .scaledToFill()
            .foregroundColor(icon.iconTheme.shape != .transparent ? icon.iconTheme.backgroundColor : .clear)
            .padding(icon.iconTheme.shape != .transparent ? 5 : 0)
            .shadow(color: Color.black.opacity(icon.iconTheme.shapeShadow ? 0.25 : 0), radius: 1.6, y: 2.0)
    }
    
    var iconView: some View {
        Image(nsImage: icon.appIcon)
            .resizable()
            .scaledToFill()
            .padding(icon.iconTheme.shape != .transparent ? 8 : 0)
            .shadow(color: Color.black.opacity(icon.iconTheme.iconShadow ? 0.25 : 0), radius: 1.6, y: 2.0)
    }
    
    var iconText: some View {
        Text(icon.name)
            .font(.system(size: 11, weight: .regular))
            .multilineTextAlignment(.center)
            .padding(3)
    }
    
    private func selectionColor(_ viewStore: ViewStore<ThemeState, ThemeAction>) -> Color {
        Color.secondary.opacity(isSelected(viewStore) ? 1 : 0)
    }
    
    private func isSelected(_ viewStore: ViewStore<ThemeState, ThemeAction>) -> Bool {
        viewStore.selectedIconState.icons.firstIndex(of: icon) != nil
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        var icon = Icon(path: "/Applications/Pages.app")
        
        icon.iconTheme.shape = .roundedRectangle
        return IconView(store: ThemeState.defaultStore, icon: icon)
    }
}
