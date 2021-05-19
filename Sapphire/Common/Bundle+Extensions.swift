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
    
    /// Returns Bundle name from url.
    static func name(from url: String) -> String {
        url
            .replacingOccurrences(of: "/Applications/", with: "")
            .replacingOccurrences(of: ".app",           with: "")
    }
    
    /// Returns url of Bundle icon.
    static func iconURL(from url: String) -> String {
        let plist = Bundle.getSerializedPlist(from: url)
        
        let p = "\(url)/Contents/Resources/\(plist?["CFBundleIconFile"] ?? plist?["Icon file"] ?? "AppIcon")"
        
        let iconPath = p.contains(".icns")
            ? p
            : p + ".icns"
        
        return iconPath
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

extension FileManager {
    func allApplicationsDirectory() -> URL {
        return self.urls(for: .allApplicationsDirectory, in: .userDomainMask)[0]
    }
}
