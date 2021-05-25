//
//  SheetView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import SwiftUI
import ComposableArchitecture

struct SheetView: View {
    let store: Store<Grid.State, Grid.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if viewStore.onboarding {
                OnboardingView(store: store)
                
            } else if viewStore.inFlight {
                ApplyingChanges(store: store)
            }
        }
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(store: Grid.defaultStore)
    }
}



