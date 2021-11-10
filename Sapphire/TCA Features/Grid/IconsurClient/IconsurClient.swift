//
//  AppIconCustomizerClient.swift
//  Sapphire
//
//  Created by Kody Deda on 11/9/21.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct IconsurClient {
  let getIcons:   ()                                                                         -> Effect <IdentifiedArrayOf<MacOSApplicationState>, Error>
  let setIcons:  (_ applications: IdentifiedArrayOf<MacOSApplicationState>, _ color: Color) -> Effect<Bool, AppError>
  let resetIcons: (IdentifiedArrayOf<MacOSApplicationState>)                                 -> Effect<Bool, AppError>
}

extension IconsurClient {
  static var live: Self {
    let iconsur = try! FileManager.default
      .url(for: .applicationScriptsDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      .appendingPathComponent("sapphire")
      .appleScriptFormat
    
    let applescriptURL = try! FileManager.default
      .url(for: .applicationScriptsDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      .appendingPathComponent("AppleScript")
      .appendingPathExtension(for: .osaScript)
    
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
        Effect.future { callback in
          // Command |> writeToUrl >>> execute
          // Create a publisher that tries to do all of it.

          let command = applications
            .map { "\(iconsur) set \($0.bundleURL.appleScriptFormat) -l -s 0.8 -c \(color.hex); " }
            .joined()
            .appending("\(iconsur) cache")

          try! "do shell script \"\(command)\" with administrator privileges".write(to: applescriptURL, atomically: true, encoding: .utf8)
          
          try! NSUserAppleScriptTask(url: applescriptURL).execute(completionHandler: { error in
            if let error = error {
              callback(.failure(.init(error)))
            } else {
              callback(.success(true))
            }
          })
        }
      },
      resetIcons: { applications in
        Effect.future { callback in
          let command = applications
            .map { "\(iconsur) unset \($0.bundleURL.appleScriptFormat); " }
            .joined()
            .appending("\(iconsur) cache")

          try! "do shell script \"\(command)\" with administrator privileges".write(to: applescriptURL, atomically: true, encoding: .utf8)
          
          try! NSUserAppleScriptTask(url: applescriptURL).execute(completionHandler: { error in
            if let error = error {
              callback(.failure(.init(error)))
            } else {
              callback(.success(true))
            }
          })
        }
      }
    )
  }
}


private extension URL {
  
  /// Returns path formatted for Applescript.
  var appleScriptFormat: String {
    "\\\"\(self.path)\\\""
  }
}



// MARK: - Bundle+Extensions
private extension Bundle {
  
  /// Returns all MacOSApplication URL's.
  static var allBundleURLs: [URL] {
    try! FileManager
      .default
      .contentsOfDirectory(atPath: "/Applications")
      .map { URL(fileURLWithPath: "/Applications/".appending($0)) }
      .filter { $0.path.contains(".app") }
  }
  
  /// Returns Bundle name from URL.
  static func getName(from url: URL) -> String {
    url
      .deletingPathExtension()
      .lastPathComponent
  }
  
  /// Returns Bundle icon-url from URL.
  static func getIcon(from url: URL) -> URL {
    url
      .appendingPathComponent("/Contents/Resources/")
      .appendingPathComponent("\(Bundle.getSerializedInfoPlist(from: url)["CFBundleIconFile"] ?? "AppIcon")")
      .appendingPathExtension(for: .icns)
  }
  
  /// Returns Bundle Serialized-Info-Plist as [String : Any]? from URL.
  static func getSerializedInfoPlist(from url: URL) -> [String : Any] {
    let url = URL(fileURLWithPath: url.path.appending("/Contents/Info.plist"))
    
    if let data = try? Data(contentsOf: url) {
      do {
        if let dict = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] {
          return dict
        }
      } catch {
        print(error)
      }
    }
    return ["":""]
  }
}

