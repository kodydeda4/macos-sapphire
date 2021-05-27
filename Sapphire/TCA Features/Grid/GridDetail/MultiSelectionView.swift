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
            VStack {
                GroupBox {
                    ScrollView {
                        LazyVGrid(columns: [GridItem](repeating: .init(.flexible()), count: 3)) {
                            ForEachStore(store.scope(
                                state: { $0.macOSApplications.filter(\.selected) },
                                action: Grid.Action.macOSApplication(index:action:)
                            )) { childStore in
                                WithViewStore(childStore) { childViewStore in
                                    VStack {
                                        ZStack {
                                            Image(systemName: "app.fill")
                                                .resizable()
                                                .scaledToFill()
                                                .padding(5)
                                                .foregroundColor(viewStore.selectedColor)
                                            
                                            FetchImageView(url: childViewStore.iconURL)
                                                .padding(14)
                                        }
                                        
                                        
                                        Text(childViewStore.name)
                                            .font(.title3)
                                            .bold()
                                            .lineLimit(2)
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                }
                GridDetailButtonsView(store: store)
            }
        }
    }
}

struct MultiSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        MultiSelectionView(store: Grid.defaultStore)
    }
}
