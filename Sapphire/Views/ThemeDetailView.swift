//
//  ThemeDetailView.swift
//  Sapphire
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
            if viewStore.selectedIcons.isEmpty {
                VStack(alignment: .center) {
                    Text("No Selection")
                        .font(.title)
                        .foregroundColor(Color(NSColor.placeholderTextColor))
                }
            } else {
                ScrollView {
                    IconDetailView(
                        store: store,
                        iconFrameWidth: 125,
                        iconFrameHeight: 125,
                        iconImage: viewStore.iconDetailViewImage,
                        iconText: viewStore.iconDetailViewText
                    )
                    Divider()
                    VStack {
                        IconShapeSelectorView(
                            selection: viewStore.binding(
                                get: \.iconTheme.shape,
                                send: ThemeDetailAction.setShape))
                        Divider()
                        ColorSelectorView(
                            selection: viewStore.binding(
                                get: \.iconTheme.backgroundColor,
                                send: ThemeDetailAction.setBackgroundColor))
                        
                        Divider()
                        VStack(alignment: .leading) {
                            Toggle(isOn: viewStore.binding(
                                    get: { $0.iconTheme.iconShadow },
                                    send: ThemeDetailAction.toggleIconShadow)) {
                                Text("Icon Shadow")
                            }
                            Toggle(isOn: viewStore.binding(
                                    get: { $0.iconTheme.shapeShadow },
                                    send: ThemeDetailAction.toggleShapeShadow)) {
                                Text("Background Shadow")
                            }
                            
                        }
                    }
                }
                .padding()
                .padding(.top)
            }
        }
    }
}

// MARK:- SwiftUI Previews

struct ThemeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeDetailView(store: ThemeDetailState.defaultStore)
    }
}
