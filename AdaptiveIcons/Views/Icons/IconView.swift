//
//  IconView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/22/20.
//

import SwiftUI

struct IconView: View, Identifiable {
    var id = UUID()
    let app: AppModel
    let theme: IconThemeModel?
    
    var body: some View {
        IconViewModel(
            name: app.name,
            image: Image(contentsOfFile: app.defaultIconPath),
            theme: theme
        )
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView(app: apps[0], theme: IconThemeModel())
    }
}
