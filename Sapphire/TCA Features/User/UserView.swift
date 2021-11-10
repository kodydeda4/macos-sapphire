//
//  UserView.swift
//  Sapphire
//
//  Created by Kody Deda on 11/10/21.
//

import SwiftUI
import ComposableArchitecture

struct UserView: View {
  let store: Store<UserState, UserAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      GridView(store: store.scope(
        state: \.grid,
        action: UserAction.grid
      ))
    }
  }
}

// MARK:- SwiftUI_Previews
struct UserView_Previews: PreviewProvider {
  static var previews: some View {
    UserView(store: .default)
  }
}
