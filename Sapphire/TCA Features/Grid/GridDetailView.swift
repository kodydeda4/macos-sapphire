//
//  GridDetailView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import SwiftUI
import ComposableArchitecture

struct GridDetailView: View {
    let store: Store<Grid.State, Grid.Action>
    
    
    var body: some View {
        WithViewStore(store) { viewStore in
            switch viewStore.macOSApplications.filter(\.selected).count {
            
            case 0: NoSelectionView()
            case 1: SingleSelectionView(store: store)
            default: MultiSelectionView(store: store)
                

            }
        }
    }
}




// MARK:- SwiftUI_Previews
struct GridDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GridDetailView(store: Grid.defaultStore)
    }
}
