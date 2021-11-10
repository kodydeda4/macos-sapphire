//
//  RootState.swift
//  Sapphire
//
//  Created by Kody Deda on 11/10/21.
//

import ComposableArchitecture

enum RootState: Equatable {
  case authentication(AuthenticationState)
  case user(UserState)
}

enum RootAction: Equatable {
  case authentication(AuthenticationAction)
  case user(UserAction)
}

struct RootEnvironment {
  let scheduler: AnySchedulerOf<DispatchQueue>
}

let rootReducer = Reducer<RootState, RootAction, RootEnvironment>.combine(
  authenticationReducer.pullback(
    state: /RootState.authentication,
    action: /RootAction.authentication,
    environment: { .init(scheduler: $0.scheduler) }
  ),
  userReducer.pullback(
    state: /RootState.user,
    action: /RootAction.user,
    environment: { .init(scheduler: $0.scheduler) }
  ),
  Reducer { state, action, environment in
    switch action {
      
    case .authentication(.didSignIn):
      state = .user(.init())
      return .none
      
    case .user(.didSignout):
      state = .authentication(.init())
      return .none
      
    case .authentication, .user:
      return .none
    }
  }
)
//.debug()

extension Store where State == RootState, Action == RootAction {
  static let `default` = Store(
    initialState: .authentication(
      AuthenticationState.init(
        email: "test@email.com",
        password: "123123"
      )),
    reducer: rootReducer,
    environment: RootEnvironment(scheduler: .main)
  )
}
