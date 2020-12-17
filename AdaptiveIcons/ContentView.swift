//
//  ContentView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/15/20.
//

import SwiftUI


extension Image {
    public init?(contentsOfFile: String) {
        guard let image = NSImage(contentsOfFile: contentsOfFile)
            else { return nil }
        self.init(nsImage: image)
    }
}


struct ContentView : View {
    var body: some View {
        NavigationView {
            AppList()
            AppScrollView()
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

