//
//  Model.swift
//  AdaptiveIcons
//
//  Created by Klajd Deda on 12/24/20.
//

import Foundation
import SwiftUI
import AppKit

struct Model {
    struct App: Identifiable, Equatable, Hashable {
        enum IconState {
            case normal
            case adaptive
            case custom
        }

        let id = UUID()
        let path: String
        let iconState: IconState = .normal
        var isSelected = false
        var background = Color.clear
    }
}

extension Model.App {
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

extension Model.App {
    static func loadAppIcons(fromPath: String) -> [Model.App] {
        let start = Date()
        let rv = try? FileManager
            .default
            .contentsOfDirectory(atPath: "/Applications")
            .filter { $0.contains(".app") && !$0.hasPrefix(".") }
            .map { Model.App(path: "/Applications/\($0)" ) }
            .sorted(by: { $0.name < $1.name })
        
        iddlog("loaded in: '\(start.timeIntervalSince(Date()) * -1000) ms'")
        return rv ?? []
    }
}
