//
//  Model.swift
//  Sapphire
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI

struct MacOSApplication: Equatable, Identifiable {
    let id = UUID()
    let path: String
    
    var name: String {
        path
            .replacingOccurrences(of: "/Applications/", with: "")
            .replacingOccurrences(of: ".app", with: "")
    }
    
    var icon: NSImage {
        let p = "\(path)/Contents/Resources/\(AppBundlePlist?["CFBundleIconFile"] ?? AppBundlePlist?["Icon file"] ?? "AppIcon")"
        let iconPath = p.contains(".icns")
            ? p
            : p + ".icns"
        
        
        if let f = NSImage(contentsOfFile: iconPath) {
            return f
        } else {
            return NSImage.init()
        }
    }
}

extension MacOSApplication {
    var AppBundlePlist: [String: Any]? {
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

// MARK:- [MacOSApplication]

extension Array where Element == MacOSApplication {
    
    static var allCases: [MacOSApplication] {
        try! FileManager
            .default
            .contentsOfDirectory(atPath: "/Applications")
            .filter { $0.contains(".app") && !$0.hasPrefix(".") }
            .map { MacOSApplication(path: "/Applications/\($0)" ) }
            .sorted(by: { $0.name < $1.name })
    }
}

