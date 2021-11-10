//
//  index.swift
//  Sapphire
//
//  Created by Kody Deda on 11/10/21.
//

import Foundation

precedencegroup ForwardApplication {
  associativity: left
}
infix operator |> : ForwardApplication
public func |> <A, B>(x: A, f: (A) -> B) -> B {
  return f(x)
}
