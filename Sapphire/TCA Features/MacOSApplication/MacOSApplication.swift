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
  var colorHex      = "ffffff"
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

extension MacOSApplicationState {
  static let defaultStore = Store(
    initialState: .init(
      bundleURL: Bundle.allBundleURLs.first!,
      name: Bundle.getName(from: Bundle.allBundleURLs.first!),
      iconURL: Bundle.getIcon(from: Bundle.allBundleURLs.first!)
    ),
    reducer: macOSApplicationReducer,
    environment: ()
  )
}


extension Array where Element == MacOSApplicationState {
  
  /// Returns [MacOSApplication.State] containing all MacOSApplications.
  static var allCases: [MacOSApplicationState] {
    Bundle.allBundleURLs.map {
      MacOSApplicationState(
        bundleURL: $0,
        name: Bundle.getName(from: $0),
        iconURL: Bundle.getIcon(from: $0)
      )
    }
    .sorted(by: { $0.name < $1.name })
  }
}
