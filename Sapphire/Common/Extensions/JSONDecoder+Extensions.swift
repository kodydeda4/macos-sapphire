//
//  JSONDecoder+Extensions.swift
//  Sapphire
//
//  Created by Kody Deda on 5/20/21.
//

import Foundation

extension JSONDecoder {
  
  /// Decode a `Codable` struct from a url.
  func decodeState<State>(ofType type: State.Type, from url: URL) -> Result<State, Error> where State: Codable {
    do {
      let decoded = try JSONDecoder().decode(type.self, from: Data(contentsOf: url))
      return .success(decoded)
    }
    catch {
      return .failure(error)
    }
  }
}

extension JSONEncoder {
  
  /// Encode and write a `Codable` struct to a url.
  func writeState<State>(_ state: State, to url: URL) -> Result<Bool, Error> where State: Codable {
    do {
      try JSONEncoder()
        .encode(state)
        .write(to: url)
      return .success(true)
    } catch {
      return .failure(error)
    }
  }
}
