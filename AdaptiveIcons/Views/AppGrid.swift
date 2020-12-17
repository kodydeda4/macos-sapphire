//
//  AppScrollView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/17/20.
//

import SwiftUI

// Tutorial
//  https://www.youtube.com/watch?v=eu-YaVvsbjQ&t=4s&ab_channel=LetsBuildThatApp

struct AppGrid: View {
    var body: some View {
        LazyVGrid(columns: Array(repeating:
            GridItem(.fixed(100), spacing: 20, alignment: .top),count: 6), spacing: 12, content: {
                
            ForEach(apps) { app in
                VStack(alignment: .center, spacing: 6) {
                    
                    Image(contentsOfFile: app.defaultIconPath)?
                        .resizable()
                        .scaledToFill()
                        .frame(width: 55, height: 55)
                    Text(app.name)
                        .font(.system(size: 11, weight: .regular))
                        .multilineTextAlignment(.center)
                        .frame(width: 90, height: 30, alignment: .top)
                }
                
                .frame(width: 100, height: 100)
            }
        })
    }
}

struct AppGrid_Previews: PreviewProvider {
    static var previews: some View {
        AppGrid()
    }
}
