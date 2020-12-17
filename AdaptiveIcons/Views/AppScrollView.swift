//
//  AppScrollView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/17/20.
//

import SwiftUI

struct AppScrollView : View {
    var body: some View {

        ScrollView {
            LazyVGrid(columns: [
                GridItem(.fixed(150)),
                GridItem(.fixed(150)),
                GridItem(.fixed(150))
            ], spacing:12, content: {
                ForEach(apps) { app in
                    HStack {
                        Spacer()
                        Text("\(app.name)")
                        Spacer()
                    }
                }
                .padding()
                .background(Color.red)

            })
        }
    }
}

struct AppScrollView_Previews: PreviewProvider {
    static var previews: some View {
        AppScrollView()
    }
}
