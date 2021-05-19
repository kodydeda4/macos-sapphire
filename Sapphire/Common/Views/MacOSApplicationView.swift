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

struct MacOSApplicationView: View {
    var icon: MacOSApplication
    
    var body: some View {
        VStack {
            Image(nsImage: icon.appIcon)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .padding(.bottom, 4)
            
            Text(icon.name)
                .font(.caption)
                .lineLimit(1)
        }
        .padding()
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        MacOSApplicationView(icon: MacOSApplication.loadIcons(fromPath: "/Applications").first!)
    }
}
