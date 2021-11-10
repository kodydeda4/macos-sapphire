//
//  AuthenticationView.swift
//  Sapphire
//
//  Created by Kody Deda on 11/10/21.
//

import SwiftUI
import ComposableArchitecture

struct AuthenticationView: View {
  let store: Store<AuthenticationState, AuthenticationAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 20) {
        Text("Login")
          .font(.largeTitle)
        
        TextField("Email", text: viewStore.binding(\.$email))
        TextField("Password", text: viewStore.binding(\.$password))
        
        Button("Login") {
          viewStore.send(.signIn)
        }
      }
      .padding()
      .padding(.horizontal, 100)
      .frame(width: 540, height: 860)
      .navigationTitle("Login")
      .textFieldStyle(RoundedBorderTextFieldStyle())
    }
  }
}


struct AuthenticationView_Previews: PreviewProvider {
  static var previews: some View {
    AuthenticationView(store: .default)
  }
}





