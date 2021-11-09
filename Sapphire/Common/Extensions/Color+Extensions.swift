//
//  Color+Extensions.swift
//  Sapphire
//
//  Created by Kody Deda on 5/27/21.
//

import SwiftUI
import DynamicColor

extension Color {
  var hex: String {
    "\(DynamicColor(self).toHexString().dropFirst())"
  }
}


extension Color {
  init(fromHex hex: String) {
    self.init(DynamicColor(hexString: hex).cgColor)
  }
}
