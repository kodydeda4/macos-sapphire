//
//  LocalDataClient.swift
//  Sapphire
//
//  Created by Kody Deda on 11/9/21.
//

import ComposableArchitecture

struct LocalDataClient<State> where State: Codable {
  let save: (State) -> Effect<Bool, Error>
  let load: ()      -> Effect<State, Error>
}

extension LocalDataClient {
  static func live(url: URL) -> Self {
    return Self(
      save: { state in
        Effect.future { callback in
          do {
            try JSONEncoder().encode(state).write(to: url)
            return callback(.success(true))
          } catch {
            return callback(.failure(error))
          }
        }
      },
      load: {
        Effect.future { callback in
          do {
            let decoded = try JSONDecoder().decode(State.self, from: Data(contentsOf: url))
            return callback(.success(decoded))
          }
          catch {
            return callback(.failure(error))
          }
        }
      }
    )
  }
}
