//
//  ThemeDetailView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI
import ComposableArchitecture
import Grid
import Combine

struct ThemeDetailView: View {
    let store: Store<ThemeDetailState, ThemeDetailAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if viewStore.icons.isEmpty {
                placeholderText
                
            } else {
                ScrollView {
                    previewIcon
                    
                    VStack {
                        shapeSelectorButtons
                        colorSelectorButtons
                        
                        VStack(alignment: .leading) {
                            iconShadowToggle
                            shapeShadowToggle
                        }
                    }
                    listOfSelectedIcons
                }
            }
        }
        .padding()
        .frame(minWidth: 250)
        
    }
    
    var placeholderText: some View {
        VStack(alignment: .center) {
            Text("No Selection")
                .font(.title)
                .foregroundColor(Color(NSColor.placeholderTextColor))
        }
    }
    
    var previewIcon: some View {
        WithViewStore(store) { viewStore in
            IconDetailView(
                store: store,
                iconFrameWidth: 100,
                iconFrameHeight: 100,
                iconImage: viewStore.iconDetailViewImage,
                iconText: viewStore.iconDetailViewText)
        }
    }
    
    var shapeSelectorButtons: some View {
        WithViewStore(store) { viewStore in
            IconShapeSelectorView(
                selection: viewStore.binding(
                    get: \.iconTheme.shape,
                    send: ThemeDetailAction.setShape))
        }
    }
    
    var colorSelectorButtons: some View {
        WithViewStore(store) { viewStore in
            ColorSelectorView(
                selection: viewStore.binding(
                    get: \.iconTheme.backgroundColor,
                    send: ThemeDetailAction.setBackgroundColor))
        }
    }
    var iconShadowToggle: some View {
        WithViewStore(store) { viewStore in
            Toggle(isOn: viewStore.binding(
                    get: { $0.iconTheme.iconShadow },
                    send: ThemeDetailAction.toggleIconShadow)) {
                Text("Icon Shadow")
            }
        }
    }
    
    var shapeShadowToggle: some View {
        WithViewStore(store) { viewStore in
            Toggle(isOn: viewStore.binding(
                    get: { $0.iconTheme.shapeShadow },
                    send: ThemeDetailAction.toggleShapeShadow)) {
                Text("Background Shadow")
            }
        }
    }
    
    var listOfSelectedIcons: some View {
        WithViewStore(store) { viewStore in
            Text("Selected Icons:")
            List(viewStore.icons) { icon in
                Text(icon.name)
            }
        }
    }
}





struct ThemeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeDetailView(store: ThemeDetailState.defaultStore)
    }
}
