//
//  IconView.swift
//  Sapphire
//
//  Created by Kody Deda on 12/25/20.
//

import SwiftUI
import Combine
import ComposableArchitecture
import Grid

struct IconView: View {
    var icon: Icon
    
    var body: some View {
        Image(nsImage: icon.appIcon)
            .resizable()
            .scaledToFill()
            .frame(width: 50, height: 50)
            .padding()
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView(icon: Icon.loadIcons(fromPath: "/Applications").first!)
    }
}
