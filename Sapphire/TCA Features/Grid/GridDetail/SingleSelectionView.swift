//
//  SingleSelectionView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/27/21.
//

import SwiftUI
import ComposableArchitecture

struct SingleSelectionView: View {
    let store: Store<Grid.State, Grid.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ForEachStore(store.scope(
                state: { $0.macOSApplications.filter(\.selected) },
                action: Grid.Action.macOSApplication(index:action:)
            )) { childStore in
                WithViewStore(childStore) { childViewStore in
                    VStack {
                        GroupBox {
                            
                            ZStack {
                                Image(systemName: "app.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .padding(5)
                                    .foregroundColor(viewStore.selectedColor)
                                
                                FetchImageView(url: childViewStore.iconURL)
                                    .padding(14)
                            }
                            .padding()
                            .frame(width: 125, height: 125)
                        }
                        .padding()
                        
                        Text(childViewStore.name)
                            .font(.title3)
                            .bold()
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                        
                        GridDetailButtonsView(store: store)
                    }
                }
            }
        }
    }
}

// by default nothing will be selected, so this is kinda f'ed rn.
struct SingleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SingleSelectionView(store: Grid.defaultStore)
    }
}
