//
//  AppList.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/17/20.
//

import SwiftUI

struct AppList : View {
    var body: some View {
        List(apps) { app in
            HStack {
                Image(contentsOfFile: app.defaultIconPath)?.resizable()
                    .frame(width: 20, height: 20)
                Text(app.name)

            }
        }
    }
}

struct AppList_Previews: PreviewProvider {
    static var previews: some View {
        AppList()
    }
}
