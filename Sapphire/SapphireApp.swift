//
//  SapphireApp.swift
//  Sapphire
//
//  Created by Kody Deda on 12/15/20.
//

import SwiftUI
import ComposableArchitecture

@main
struct SapphireApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(store: Grid.defaultStore)
        }
    }
}

