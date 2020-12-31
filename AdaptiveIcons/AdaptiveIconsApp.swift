//
//  AdaptiveIconsApp.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/15/20.
//

import SwiftUI
import ComposableArchitecture

@main
struct AdaptiveIconsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: AppState.defaultStore)
        }
    }
}
