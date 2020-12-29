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
                Text("Customize")

                HStack {
                    Button(
                        action: { viewStore.send(.setSelectedIconShape(IconShape.roundedRectangle)) }) {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 40, height: 40)
                    }.buttonStyle(PlainButtonStyle())
                    
                    Button(
                        action: { viewStore.send(.setSelectedIconShape(IconShape.circle)) }) {
                        Circle()
                            .frame(width: 40, height: 40)
                    }.buttonStyle(PlainButtonStyle())
                    
                    Button(
                        action: { viewStore.send(.setSelectedIconShape(IconShape.roundedRectangle)) }) {
                        Circle()
                            .foregroundColor(Color.gray)
                            .frame(width: 40, height: 40)
                    }.buttonStyle(PlainButtonStyle())
                }
                
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
