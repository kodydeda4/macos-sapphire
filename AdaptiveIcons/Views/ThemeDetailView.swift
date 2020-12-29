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
            VStack(alignment: .leading) {
                
                ColorPicker("Color",
                    selection: viewStore.binding(
                        get: \.backgroundColorSelection,
                        send: AppAction.setBackgroundColorSelection))
                
                Picker("Shape",
                    selection: viewStore.binding(
                        get: \.iconShapeSelection,
                        send: AppAction.setIconShapeSelection),
                    content: {
                        ForEach(IconShape.allCases, id: \.self) {
                            Text($0.rawValue) }})
                
                Button("Apply Changes",
                    action: { viewStore.send(.applyChangesButtonPressed) })
            }
        }
    }
}

struct ThemeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeDetailView(store: defaultStore)
    }
}
