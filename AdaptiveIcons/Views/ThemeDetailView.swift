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
//    @State var selection = IconShape.roundedRectangle
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                ScrollView {
                    Grid(Array(viewStore.icons.filter(\.isSelected))) { icon in
                        IconView(store: store, icon: icon)
                    }.padding(16)
                }
                Picker(
                    selection: viewStore.binding(
                        get: \.iconShapeSelection,
                        send: AppAction.setIconShapeSelection),
                    label: Text("Picker"),
                    content: {
                        ForEach(IconShape.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                })

//                Picker(selection: $selection, label: Text("shape")) {
//                    ForEach(IconShape.allCases, id: \.self) {
//                        Text($0.rawValue)
//                    }
//                }
                
//                IconView(store: store, icon: viewStore)
                
                HStack {
                    Button(action: { viewStore.send(.setBackgroundForSelectedIcons(Color.white)) }) {
                        Text("Add White Background")
                    }
                }
                Spacer()
            }
        }
    }
}

struct ThemeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeDetailView(store: defaultStore)
    }
}
