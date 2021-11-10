//
//  MacOSApplication.swift
//  Sapphire
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI
import ComposableArchitecture

struct MacOSApplicationState : Equatable, Identifiable, Hashable, Codable {
  var id         : URL { bundleURL }
  var bundleURL  : URL
  let name       : String
  var iconURL    : URL
  var colorHex   = "ffffff"
  var selected   = false
  var modified   = false
}

enum MacOSApplicationAction: Equatable {
  case toggleSelected
  case toggleCustom
  case modifyIconButtonTapped
}

let macOSApplicationReducer = Reducer<MacOSApplicationState, MacOSApplicationAction, Void>.combine(
  Reducer { state, action, _ in
    switch action {
      
    case .toggleSelected:
      return .none
      
    case .toggleCustom:
      state.modified.toggle()
      return .none
      
    case .modifyIconButtonTapped:
      return .none
      
    }
  }
)
