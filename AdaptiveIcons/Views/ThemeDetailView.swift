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
                
                Divider()
                HStack {
                    Button(action: { viewStore.send(.setSelectedIconShape(.roundedRectangle)) }) {
                    Image(systemName: "square.fill")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(viewStore.selectedIconShape == .roundedRectangle ? .accentColor : .gray)
                        .frame(width: 40, height: 40)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: { viewStore.send(.setSelectedIconShape(.circle)) }) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(viewStore.selectedIconShape == .circle ? .accentColor : .gray)
                        .frame(width: 40, height: 40)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: { viewStore.send(.setSelectedIconShape(.none)) }) {
                    Image(systemName: "circle.dashed")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(viewStore.selectedIconShape == nil ? .accentColor : .gray)
                        .frame(width: 40, height: 40)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                Divider()
                
                ColorPicker("Color",
                    selection: viewStore.binding(
                        get: \.selectedBackgroundColor,
                        send: AppAction.setSelectedBackgroundColor))
                
//                Picker("Shape",
//                    selection: viewStore.binding(
//                        get: \.selectedIconShape,
//                        send: AppAction.setSelectedIconShape),
//                    content: {
//                        ForEach(IconShape.allCases, id: \.self) {
//                            Text($0.rawValue) }})

                Toggle(isOn: viewStore.binding(
                        get: \.selectedIconShadow,
                        send: AppAction.setSelectedIconShadow)) {
                    Text("Icon Shadow")
                }
                
                Toggle(isOn: viewStore.binding(
                        get: \.selectedShapeShadow,
                        send: AppAction.setSelectedShapeShadow)) {
                    Text("Shape Shadow")
                }
                
                Button("Remove Changes",
                    action: { viewStore.send(.removeChanges) })
                
                Button("Apply Changes",
                       action: { viewStore.send(.applyChanges) })
                
                Text(viewStore.selectedIconShape.debugDescription)
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
