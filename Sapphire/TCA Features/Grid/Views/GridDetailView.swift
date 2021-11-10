//
//  GridDetailView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import SwiftUI
import ComposableArchitecture

struct GridDetailView: View {
  let store: Store<GridState, GridAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      if viewStore.macOSApplications.filter(\.selected).isEmpty {
        Text("No Selection")
          .font(.title)
          .foregroundColor(Color(.disabledControlTextColor))
      } else {
        VStack {
          GroupBox {
            GridSelectionView(store: store)
          }
          GroupBox {
            ColorSelectorView(selection: viewStore.binding(\.$selectedColor))
          }
          .padding(.vertical)
        }
        .frame(width: 350)
        .padding()
        .toolbar {
          ToolbarItem {
            Button("Reset") { viewStore.send(.createResetIconsAlert) }
          }
          ToolbarItem {
            Button("Apply") { viewStore.send(.createSetIconsAlert) }
          }
        }
      }
    }
  }
}




// MARK:- SwiftUI_Previews
struct GridDetailView_Previews: PreviewProvider {
  static var previews: some View {
    GridDetailView(store: .default)
  }
}
