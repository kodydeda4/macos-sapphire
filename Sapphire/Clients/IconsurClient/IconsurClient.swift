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
  let setIcons:   (_ applications: IdentifiedArrayOf<MacOSApplicationState>, _ color: Color) -> Effect<GridAction, Never>
  let resetIcons: (IdentifiedArrayOf<MacOSApplicationState>)                                 -> Effect<GridAction, Never>
}

extension IconsurClient {
  static var live: Self {
    let iconsur = try! FileManager.default
      .url(for: .applicationScriptsDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      .appendingPathComponent("sapphire")
      .formattedForApplescript
    
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
          .map { "\(iconsur) set \($0.bundleURL.formattedForApplescript) -l -s 0.8 -c \(color.hex); " }
          .joined()
          .appending("\(iconsur) cache")
        
        return NSUserAppleScriptTask()
          .execute(command)
          .map(GridAction.didSetSystemApplications) // <-- wot 0
          .receive(on: DispatchQueue.main)          // <-- wot 1
          .eraseToEffect()                          // <-- wot 2
        
      },
      resetIcons: { applications in
        let command = applications
          .map { "\(iconsur) unset \($0.bundleURL.formattedForApplescript); " }
          .joined()
          .appending("\(iconsur) cache")
        
        return NSUserAppleScriptTask()
          .execute(command)
          .map(GridAction.didResetSystemApplications)
          .receive(on: DispatchQueue.main)
          .eraseToEffect()
      }
    )
  }
}


private extension URL {
  
  /// Returns path formatted for Applescript.
  var formattedForApplescript: String {
    "\\\"\(self.path)\\\""
  }
}

// MARK: - NSUserAppleScriptTask+Extensions
private extension NSUserAppleScriptTask {
  
  /// Writes command to ~/ApplicationScripts/`AppName`/Applescript.osa file & executes it
  func execute(_ command: String) -> AnyPublisher<Result<Bool, AppError>, Never> {
    let rv = PassthroughSubject<Result<Bool, AppError>, Never>()
    
    let url = try! FileManager.default.url(for: .applicationScriptsDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      .appendingPathComponent("AppleScript")
      .appendingPathExtension(for: .osaScript)
    
    
    do {
      try "do shell script \"\(command)\" with administrator privileges".write(to: url, atomically: true, encoding: .utf8)
      try NSUserAppleScriptTask(url: url).execute(completionHandler: { error in
        guard error != nil
        else {
          rv.send(.success(true))
          return
        }
      })
    }
    catch {
      rv.send(.failure(.init(error)))
    }
    
    return rv.eraseToAnyPublisher()
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

