//
//  Bundle+Extensions.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import Foundation

extension Bundle {
  
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

