//
//  ThemePrimaryView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI
import Combine
import ComposableArchitecture

struct ThemePrimaryView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            Text("1234")
        }
//        WithViewStore(store) { viewStore
////
////            ScrollView {
////                Grid(viewStore.appIcons) { icon in
////                    IconView(app: icon, selectedIconViews: $selectedIconViews)
////                }.padding(16)
////            }
//        }
    }
}

struct ThemePrimaryView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePrimaryView(store: mockupStore)
    }
}
