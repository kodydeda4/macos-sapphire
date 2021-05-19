//
//  MacOSApplication+Extensions.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import Foundation

extension Array where Element == MacOSApplication.State {
    
    /// Returns [MacOSApplication.State] with all MacOSApplications.
    static var allCases: [MacOSApplication.State] {
        Bundle.allBundleURLs.map {
            MacOSApplication.State(
                url: $0,
                name: Bundle.name(from: $0),
                icon: Bundle.icon(from: $0)
            )
        }
    }
}
