//
//  SapphireApp.swift
//  Sapphire
//
//  Created by Kody Deda on 12/15/20.
//

import SwiftUI
import ComposableArchitecture
import Firebase

@main
struct SapphireApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            GridView(store: Grid.defaultStore)
//            BooksListView(store: BooksList.defaultStore)
        }
    }
}

