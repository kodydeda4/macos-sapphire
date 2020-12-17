//
//  AppScrollView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/17/20.
//

import SwiftUI
// Tutorial
//  https://www.youtube.com/watch?v=eu-YaVvsbjQ&t=4s&ab_channel=LetsBuildThatApp
struct AppScrollView : View {
    var body: some View {

        ScrollView {
            LazyVGrid(columns: Array(repeating:
                GridItem(.fixed(100), spacing: 12, alignment: .top), count: 5),

            alignment: .center, spacing: 12, content: {
                ForEach(apps) { app in
            
                    VStack(alignment: .center, spacing: 4) {
                        Spacer()
                        Image(contentsOfFile: app.defaultIconPath)?
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                        Text(app.name)
//                            .padding(.top, 4)
                            .font(.system(size: 9, weight: .regular))
                        Spacer()
                    }
                    .frame(width: 100, height: 100)
                }
//                .padding(.horizontal)
                .background(Color.red.opacity(0.1))

            }).padding(.horizontal, 12)
        }
    }
}

struct AppScrollView_Previews: PreviewProvider {
    static var previews: some View {
        AppScrollView()
    }
}
