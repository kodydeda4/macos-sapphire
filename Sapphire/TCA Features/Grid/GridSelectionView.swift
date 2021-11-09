//
//  GridSelectionView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/27/21.
//

import SwiftUI
import ComposableArchitecture

struct GridSelectionView: View {
  let store: Store<Grid.State, Grid.Action>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      ScrollView {
        LazyVGrid(columns: [GridItem](repeating: .init(.fixed(100)), count: 3)) {
          ForEachStore(store.scope(
            state: { $0.macOSApplications.filter(\.selected) },
            action: Grid.Action.macOSApplication(index:action:)
          )) { childStore in
            
            WithViewStore(childStore) { childViewStore in
              //MARK:-
              VStack {
                ZStack {
                  Image(systemName: "app.fill")
                    .resizable()
                    .scaledToFill()
                    .padding(5)
                    .foregroundColor(viewStore.selectedColor)
                    .shadow(color: Color.black.opacity(0.25), radius: 0.75, y: 0.75)
                  
                  
                  FetchImageView(url: childViewStore.iconURL)
                    .padding(14)
                }
                .frame(width: 75, height: 75)
                
                
                Text(childViewStore.name)
                  .lineLimit(2)
                  .multilineTextAlignment(.center)
                
                Spacer()
              }
              .padding(.top)
            }
          }
        }
      }
    }
  }
}

// MARK:- SwiftUI_Previews
struct GridSelectionView_Previews: PreviewProvider {
  static var previews: some View {
    GridSelectionView(store: Grid.defaultStore)
  }
}

