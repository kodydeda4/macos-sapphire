//
//  Model.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/24/20.
//

import Foundation
import SwiftUI
import AppKit

struct Icon: Identifiable, Hashable {
    let id = UUID()
    let path: String
    var isSelected = false
    var backgroundColor: Color?
    var shape: IconShape?
    var shadow: Bool = false
//    var padding: CGFloat = 0
}

extension Icon {
    static var iconsByPath = [String: NSImage]()
    
    var name: String {
        path
        .replacingOccurrences(of: "/Applications/", with: "")
        .replacingOccurrences(of: ".app", with: "")
    }

    var appIcon: NSImage {
        let iconPath = defaultIconPath
        var icon = Self.iconsByPath[iconPath]
        
        if icon == nil {
            let start = Date()
            icon = NSImage(contentsOfFile: defaultIconPath)!
            Self.iconsByPath[iconPath] = icon
            iddlog("loaded in: '\(start.timeIntervalSince(Date()) * -1000) ms'")
        }
        
        return icon!
    }
    
    var defaultIconPath: String {
        let rv = "\(path)/Contents/Resources/\(AppBundlePlist?["CFBundleIconFile"] ?? AppBundlePlist?["Icon file"] ?? "AppIcon")"
        return rv.contains(".icns")
            ? rv
            : rv + ".icns"
    }

    var description: String { "AnApp<\(name)> \n path: \(path), \n defaultIconPath: \(defaultIconPath)" }

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

extension Icon {
    static func loadIcons(fromPath: String) -> [Icon] {
        let start = Date()
        let rv = try? FileManager
            .default
            .contentsOfDirectory(atPath: "/Applications")
            .filter { $0.contains(".app") && !$0.hasPrefix(".") }
            .map { Icon(path: "/Applications/\($0)" ) }
            .sorted(by: { $0.name < $1.name })
        
        iddlog("loaded in: '\(start.timeIntervalSince(Date()) * -1000) ms'")
        return rv ?? []
    }
}
