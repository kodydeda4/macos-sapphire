//
//  Bundle+Extensions.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import Foundation
import Cocoa

extension Bundle {
    
    /// Returns all MacOSApplication URL's.
    static var allBundleURLs: [URL] {
        try! FileManager
            .default
            .contentsOfDirectory(atPath: "/Applications")
            .filter { $0.contains(".app")   }
            .map    { URL(fileURLWithPath: "/Applications/\($0)") }
    }
    
    /// Returns Bundle name from URL.
    static func name(from url: URL) -> String {
        url
            .deletingPathExtension()
            .lastPathComponent
    }
    
    /// Returns Bundle icon-url from URL.
    static func icon(from url: URL) -> String {
        let p = Bundle.getSerializedInfoPlist(from: url)
        
        return "\(url.path.appending("/Contents/Resources/"))\(p?["CFBundleIconFile"] ?? p?["Icon file"] ?? "AppIcon")"
            .replacingOccurrences(of: ".icns", with: "")
            .appending(".icns")
    }
    
    /// Returns Bundle Serialized-Info-Plist as [String : Any]? from URL.
    static func getSerializedInfoPlist(from url: URL) -> [String: Any]? {
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
