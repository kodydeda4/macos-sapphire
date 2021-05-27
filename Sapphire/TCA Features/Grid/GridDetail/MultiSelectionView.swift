//
//  MultiSelectionView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/27/21.
//

import SwiftUI
import ComposableArchitecture

struct MultiSelectionView: View {
    let store: Store<Grid.State, Grid.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
        }
    }
}

struct MultiSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        MultiSelectionView(store: Grid.defaultStore)
    }
}
