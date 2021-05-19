//
//  Bundle+Extensions.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import Foundation

extension Bundle {
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
