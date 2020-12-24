//
//  ThemeDetailView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI
import Combine
import ComposableArchitecture

struct ThemeDetailView: View {
    let store: Store<AppState, AppAction>
//    @Binding var selectedIconViews: [IconView]

    var body: some View {
        Text("Detail")
//        ScrollView {
//            Grid(selectedIconViews) { iconView in
//                iconView
//            }.padding(16)
//        }
    }
}

struct ThemeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeDetailView(store: mockupStore)
    }
}
