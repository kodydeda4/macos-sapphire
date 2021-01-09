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
    let store: Store<ThemeDetailState, ThemeDetailAction>
    var iconFrameWidth: CGFloat
    var iconFrameHeight: CGFloat
    
    var iconImage: Image
    var iconText: Text
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                ZStack {
                    shape
                    image
                }
                label
            }
        }
    }
    

    
    var shape: some View {
        WithViewStore(store) { viewStore in
            Image(systemName: viewStore.iconTheme.shape.rawValue)
                .resizable()
                .scaledToFill()
                .foregroundColor(
                    viewStore.iconTheme.backgroundColor.opacity(
                        viewStore.iconTheme.shape != .transparent
                            ? 1
                            : 0
                    ))
                .shadow(color: Color.black.opacity(
                    viewStore.iconTheme.shapeShadow
                        ? 0.25
                        : 0
                ),
                radius: 1.6,
                y: 2.0
                )
                .frame(width: iconFrameWidth, height: iconFrameHeight)
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
                        .contains(viewStore.iconTheme.backgroundColor)
                        ? Color.accentColor
                        : .white
                )
                .shadow(
                    color: Color.black
                        .opacity(
                            viewStore.iconTheme.iconShadow
                                ? 0.25
                                : 0
                        ),
                    radius: 1.6,
                    y: 2.0
                )
                .frame(width: iconFrameWidth, height: iconFrameWidth)
        }
    }
    
    var label: some View {
        WithViewStore(store) { viewStore in
            iconText
                .font(.system(size: 14, weight: .regular))
                .multilineTextAlignment(.center)
                .padding(3)
        }
    }
}

struct IconDetailView_Previews: PreviewProvider {
    static var previews: some View {
        IconDetailView(
            store: ThemeDetailState.defaultStore,
            iconFrameWidth: 100,
            iconFrameHeight: 100,
            iconImage: Image(systemName: "scribble.variable"),
            iconText: Text("Preview")
        )
    }
}
