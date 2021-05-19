//
//  Bundle+Extensions.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import Foundation
import Cocoa

extension Bundle {
    
    /// Returns [String] containing all the Paths for each MacOS Application.
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
        let plist = Bundle.getSerializedPlist(from: url)
        
        let p = "\(url)/Contents/Resources/\(plist?["CFBundleIconFile"] ?? plist?["Icon file"] ?? "AppIcon")"
        
        return p.contains(".icns") ? p : p + ".icns"
        
    }
    

    static func getSerializedPlist(from path: String) -> [String: Any]? {
        if let infoPlistPath = try? URL(fileURLWithPath: "\(path)/Contents/Info.plist") {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)
                
                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any] {
                    return dict
                }
            } catch {
                print(error)
            }
        }
        return ["":""]
    }
}
