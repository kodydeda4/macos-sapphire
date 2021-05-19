//
//  Model.swift
//  Sapphire
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI

struct MacOSApplication: Equatable, Identifiable {
    var id: String { path }
    let path: String
    let name: String
    let icon: String
}

// MARK:- [MacOSApplication]
extension Array where Element == MacOSApplication {
    
    static var allCases: [MacOSApplication] {
        Bundle.allBundleURLs.map { url in
            MacOSApplication(
                path: url,
                name: Bundle.name(from: url),
                icon: Bundle.icon(from: url)
            )
        }
        .sorted(by: { $0.name < $1.name })
    }
}

