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
                        get: \.selectedBackgroundColor,
                        send: AppAction.setSelectedBackgroundColor))
                
                Picker("Shape",
                    selection: viewStore.binding(
                        get: \.selectedIconShape,
                        send: AppAction.setSelectedIconShape),
                    content: {
                        ForEach(IconShape.allCases, id: \.self) {
                            Text($0.rawValue) }})

                Toggle(isOn: viewStore.binding(
                        get: \.selectedShadow,
                        send: AppAction.setSelectedShadow)) {
                    Text("Shadow")
                }
                
                Button("Remove Changes",
                    action: { viewStore.send(.removeChanges) })
                
                Button("Apply Changes",
                       action: { viewStore.send(.applyChanges) })
            }
            .padding()
        }
    }
}

struct ThemeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeDetailView(store: defaultStore)
    }
}
