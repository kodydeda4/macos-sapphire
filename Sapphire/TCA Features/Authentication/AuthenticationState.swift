//
//  AuthenticationState.swift
//  Sapphire
//
//  Created by Kody Deda on 11/10/21.
//

import ComposableArchitecture
import AuthenticationServices

struct AuthenticationState: Equatable {
  @BindableState var email = String()
  @BindableState var password = String()
}

enum AuthenticationAction: BindableAction, Equatable {
  case binding(BindingAction<AuthenticationState>)
  case signIn
  case didSignIn
}

struct AuthenticationEnvironment {
  let scheduler: AnySchedulerOf<DispatchQueue>
}

let authenticationReducer = Reducer<
  AuthenticationState,
  AuthenticationAction,
  AuthenticationEnvironment
> { state, action, environment in
  
  switch action {
    
  case .binding:
    return .none
    
  case .signIn:
    return Effect(value: .didSignIn)
  
  case .didSignIn:
    return .none

  }
}
.binding()
.debug()

extension Store where State == AuthenticationState, Action == AuthenticationAction {
  static let `default` = Store(
    initialState: .init(),
    reducer: authenticationReducer,
    environment: AuthenticationEnvironment(
      scheduler: .main
    )
  )
}
