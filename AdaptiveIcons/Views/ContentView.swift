//
//  ContentView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/15/20.
//

import SwiftUI

struct ContentView : View {
    var body: some View {
        NavigationView {
            SidebarView()
            ThemeView(iconPack: iconPacks[0])
//            DetailView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}







