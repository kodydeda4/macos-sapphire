//
//  IconDetailView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/31/20.
//

import SwiftUI
import Combine
import ComposableArchitecture
import Grid

struct IconDetailView: View {
    let store: Store<AppState, AppAction>
    var iconImage: Image
    var iconText:  String
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                ZStack {
                    shape
                    image
                }
                .frame(width: 100, height: 100)
                label
            }
        }
    }
    
    var shape: some View {
        WithViewStore(store) { viewStore in
            Image(systemName: viewStore.selectedIconShape?.rawValue ?? "app.fill")
                .resizable()
                .scaledToFill()
                .foregroundColor(
                    viewStore.selectedBackgroundColor.opacity(
                        viewStore.selectedIconShape != nil
                            ? 1
                            : 0
                    ))
                .shadow(color: Color.black.opacity(
                    viewStore.shapeShadow
                        ? 0.25
                        : 0
                ),
                radius: 1.6,
                y: 2.0
                )
        }
    }
    
    var image: some View {
        WithViewStore(store) { viewStore in
            iconImage
                .resizable()
                .scaledToFill()
                .padding()
                .foregroundColor(
                    [.white, .black]
                        .contains(viewStore.selectedBackgroundColor)
                        ? Color.accentColor
                        : .white
                )
                .shadow(
                    color: Color.black
                        .opacity(
                            viewStore.iconShadow
                                ? 0.25
                                : 0
                        ),
                    radius: 1.6,
                    y: 2.0
                )
        }
    }
    
    var label: some View {
        Text("Preview") //Text(iconData.name)
            .font(.system(size: 14, weight: .regular))
            .multilineTextAlignment(.center)
            .padding(3)
    }
}

struct IconDetailView_Previews: PreviewProvider {
    static var previews: some View {
        IconDetailView(store: defaultStore,
                       iconImage: Image(systemName: "scribble.variable"),
                       iconText: "Preview"
        )
    }
}
