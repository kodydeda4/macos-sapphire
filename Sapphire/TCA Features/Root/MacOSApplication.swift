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
    let name: String
    
    var icon: NSImage {
        let AppBundlePlist = Bundle.getSerializedPlist(from: path)
        let p = "\(path)/Contents/Resources/\(AppBundlePlist?["CFBundleIconFile"] ?? AppBundlePlist?["Icon file"] ?? "AppIcon")"
        
        let iconPath = p.contains(".icns")
            ? p
            : p + ".icns"
        
        print(iconPath)


        if let f = NSImage(contentsOfFile: iconPath) {
            return f
        } else {
            return NSImage.init()
        }
    }
}



// MARK:- [MacOSApplication]

extension Array where Element == MacOSApplication {
    
    static var allCases: [MacOSApplication] {
        try! FileManager
            .default
            .contentsOfDirectory(atPath: "/Applications")
            .filter { $0.contains(".app") && !$0.hasPrefix(".") }
            .map {
                let path = "/Applications/\($0)"
                return MacOSApplication(
                    path: path,
                    name: path
                        .replacingOccurrences(of: "/Applications/", with: "")
                        .replacingOccurrences(of: ".app", with: "")

                )
            }
            .sorted(by: { $0.name < $1.name })
    }
}

