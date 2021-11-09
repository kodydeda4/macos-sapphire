//
//  LocalDataClient.swift
//  Sapphire
//
//  Created by Kody Deda on 11/9/21.
//

import ComposableArchitecture

struct LocalDataClient<State> where State: Codable {
  let read:  ()      -> Effect<State, Error>
  let write: (State) -> Effect<Bool, Error>
}

extension LocalDataClient {
  static func live(url: URL) -> Self {
    return Self(
      read: {
        Effect.future { callback in
          do {
            let decoded = try JSONDecoder().decode(State.self, from: Data(contentsOf: url))
            return callback(.success(decoded))
          }
          catch {
            return callback(.failure(error))
          }
        }
      },
      write: { state in
          Effect.future { callback in
            do {
              try JSONEncoder().encode(state).write(to: url)
              return callback(.success(true))
            } catch {
              return callback(.failure(error))
            }
          }
      }
    )
  }
}
