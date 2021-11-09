//
//  Button+Extensions.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import SwiftUI

extension Button {
  
  /// Create a Button using an SF Symbol
  init(_ systemImage: String, action: @escaping () -> Void) {
    self.init(
      action: action,
      label: { Image(systemName: systemImage) as! Label }
    )
  }
}

struct Button_Extensions_Previews: PreviewProvider {
  static var previews: some View {
    Button<Image>("keyboard") {
      // Action
    }
  }
}
