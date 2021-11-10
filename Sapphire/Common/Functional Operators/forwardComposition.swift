//
//  forwardComposition.swift
//  Sapphire
//
//  Created by Kody Deda on 11/10/21.
//

import Foundation

precedencegroup ForwardComposition {
  associativity: left
  higherThan: ForwardApplication
}
infix operator >>> : ForwardComposition
public func >>> <A, B, C>(
  f: @escaping (A) -> B,
  g: @escaping (B) -> C
) -> ((A) -> C) {
  
  return { g(f($0)) }
}
