//
//  AppIconCustomizerClient.swift
//  Sapphire
//
//  Created by Kody Deda on 11/9/21.
//

import ComposableArchitecture
import SwiftUI
import IdentifiedCollections

struct IconsurClient {
  let getIcons:   () -> Effect <IdentifiedArrayOf<MacOSApplicationState>, Error>
  let setIcons:   (_ applications: IdentifiedArrayOf<MacOSApplicationState>, _ color: Color) -> Effect<GridAction, Never>
  let resetIcons: (IdentifiedArrayOf<MacOSApplicationState>)                                 -> Effect<GridAction, Never>
}

extension IconsurClient {
  static var live: Self {
    let scriptURL: URL = URL.ApplicationScripts.appendingPathComponent("sapphire")
    
    return Self.init(
      getIcons: {
        Effect.future { callback in
          let a = Bundle.allBundleURLs
          .map {
            MacOSApplicationState(
              bundleURL: $0,
              name: Bundle.getName(from: $0),
              iconURL: Bundle.getIcon(from: $0)
            )
          }
          .sorted(by: { $0.name < $1.name })
        
          return callback(.success(IdentifiedArray(uniqueElements: a)))
        }
      },
      setIcons: { applications, color in
        let command = applications
          .filter(\.selected)
          .map { application in
            let iconsur = scriptURL.appleScriptPath
            let app = application.bundleURL.appleScriptPath
            
            return "\(iconsur) set \(app) -l -s 0.8 -c \(color.hex); "
          }
          .joined()
          .appending("\(scriptURL.appleScriptPath) cache")
        
        return NSUserAppleScriptTask()
          .execute(command)
          .map(GridAction.setSystemApplicationsResult)
          .receive(on: DispatchQueue.main)
          .eraseToEffect()
        
      },
      resetIcons: { applications in
        let command = applications
          .filter(\.selected)
          .map { application in
            let iconsur = scriptURL.appleScriptPath
            let app = application.bundleURL.appleScriptPath
            
            return "\(iconsur) unset \(app); "
          }
          .joined()
          .appending("\(scriptURL.appleScriptPath) cache")
        
        return NSUserAppleScriptTask()
          .execute(command)
          .map(GridAction.resetSystemApplicationsResult)
          .receive(on: DispatchQueue.main)
          .eraseToEffect()
      }
    )
  }
}


private extension URL {
  
  /// Returns path formatted for Applescript.
  var appleScriptPath: String {
    "\\\"\(self.path)\\\""
  }
}
