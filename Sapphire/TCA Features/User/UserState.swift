//
//  UserState.swift
//  Sapphire
//
//  Created by Kody Deda on 11/10/21.
//

import ComposableArchitecture

struct UserState: Equatable {
  var grid = GridState()
}

enum UserAction: Equatable {
  case grid(GridAction)
  case signout
  case didSignout
}

struct UserEnvironment {
  let scheduler: AnySchedulerOf<DispatchQueue>
}

let userReducer = Reducer<UserState, UserAction, UserEnvironment>.combine(
  gridReducer.pullback(
    state: \.grid,
    action: /UserAction.grid,
    environment: { _ in .init() }
  ),
  Reducer { state, action, environment in
    
    switch action {
      
    case .grid:
      return .none
      
    case .signout:
      return Effect(value: .didSignout)
      
    case .didSignout:
      return .none
    }
  }
).debug()

extension Store where State == UserState, Action == UserAction {
  static let `default` = Store(
    initialState: .init(),
    reducer: userReducer,
    environment: UserEnvironment(
      scheduler: .main
    )
  )
}
