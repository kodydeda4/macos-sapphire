//
//  Model.swift
//  Sapphire
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI

struct MacOSApplication: Identifiable, Hashable {
    let id = UUID()
    let path: String
    static var iconsByPath = [String: NSImage]()
        
    var name: String {
        path
        .replacingOccurrences(of: "/Applications/", with: "")
        .replacingOccurrences(of: ".app", with: "")
    }

    var icon: NSImage {
        let iconPath = iconPath
        var icon = Self.iconsByPath[iconPath]
        
        if icon == nil {
            icon = NSImage(contentsOfFile: iconPath)!
            Self.iconsByPath[iconPath] = icon
        }
        return icon!
    }
    
    var iconPath: String {
        let rv = "\(path)/Contents/Resources/\(AppBundlePlist?["CFBundleIconFile"] ?? AppBundlePlist?["Icon file"] ?? "AppIcon")"
        return rv.contains(".icns")
            ? rv
            : rv + ".icns"
    }

    var description: String {
        "MacOSApplication<\(name)> \n path: \(path), \n defaultIconPath: \(iconPath)"
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

