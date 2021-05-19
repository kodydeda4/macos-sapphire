//
//  Bundle+Extensions.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import Foundation
import Cocoa

extension Bundle {
    
    /// Returns [String] containing all the Paths for every MacOS Application.
    static var allBundleURLs: [String] {
        try! FileManager
            .default
            .contentsOfDirectory(atPath: "/Applications")
            .filter { $0.contains(".app")   }
            .map    { "/Applications/\($0)" }
    }
    
    /// Returns name of Bundle from BundleURL.
    static func name(from url: String) -> String {
        url
            .replacingOccurrences(of: "/Applications/", with: "")
            .replacingOccurrences(of: ".app",           with: "")
    }
    
    /// Returns icon url of Bundle from BundleURL.
    static func icon(from url: String) -> String {
        let p = Bundle.getSerializedInfoPlist(from: url)
        
        return "\(url.appending("/Contents/Resources/"))\(p?["CFBundleIconFile"] ?? p?["Icon file"] ?? "AppIcon")"
            .replacingOccurrences(of: ".icns", with: "")
            .appending(".icns")
    }
    
    /// Returns Serialized Info Plist as [String : Any]?
    static func getSerializedInfoPlist(from url: String) -> [String: Any]? {
        if let data = try? Data(contentsOf: URL(fileURLWithPath: "\(url)/Contents/Info.plist")) {
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
