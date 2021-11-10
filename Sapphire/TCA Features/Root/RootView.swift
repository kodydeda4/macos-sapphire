//
//  RootView.swift
//  Sapphire
//
//  Created by Kody Deda on 11/10/21.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
  let store: Store<RootState, RootAction>
  
  var body: some View {
    SwitchStore(store) {
      CaseLet(
        state: /RootState.authentication,
        action: RootAction.authentication,
        then: AuthenticationView.init(store:)
      )
      CaseLet(
        state: /RootState.user,
        action: RootAction.user,
        then: UserView.init(store:)
      )
    }
  }
}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    RootView(store: .default)
  }
}
