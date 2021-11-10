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
          applications
            .reduce(into: []) { $0.append("\(iconsur) set \($1.bundleURL.appleScriptFormat) -l -s 0.8 -c \(color.hex); ") }
            .joined()
            .appending("\(iconsur) cache")
            .pipe { "do shell script \"\($0)\" with administrator privileges" }
            .write(to: applescriptURL)
            .pipe { try! NSUserAppleScriptTask(url: $0) }
            .execute {
              if let e = $0 { return callback(.failure(.init(e)))}
              else { return callback(.success(true)) }
            }
        }
      },
      resetIcons: { applications in
        Effect.future { callback in
          applications
            .reduce(into: []) { $0.append("\(iconsur) unset \($1.bundleURL.appleScriptFormat); ") }
            .joined()
            .appending("\(iconsur) cache")
            .pipe { "do shell script \"\($0)\" with administrator privileges" }
            .write(to: applescriptURL)
            .pipe { try! NSUserAppleScriptTask(url: $0) }
            .execute {
              if let e = $0 { return callback(.failure(.init(e)))}
              else { return callback(.success(true)) }
            }
        }
      }
    )
  }
}


// MARK: Pipe
private extension URL {
  func pipe<T>(_ f: (Self) -> T) -> T {
    f(self)
  }
}

extension String {
  func pipe<T>(_ f: (Self) -> T) -> T {
    f(self)
  }
}


// MARK: extra
extension URL {
  /// Returns path formatted for Applescript.
  var appleScriptFormat: String {
    "\\\"\(self.path)\\\""
  }
}

extension String {
  func write(to url: URL) -> URL {
    try! self.write(to: url, atomically: true, encoding: .utf8)
    return url
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

