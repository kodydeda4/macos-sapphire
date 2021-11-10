//
//  AppError.swift
//  Sapphire
//
//  Created by Kody Deda on 11/9/21.
//

import Foundation

struct AppError: Equatable, Error {
  let rawValue: String
  
  init(_ error: Error) {
    self.rawValue = error.localizedDescription
  }
}

extension AppError {
  init(rawValue: String) {
    self.rawValue = rawValue
  }
}
