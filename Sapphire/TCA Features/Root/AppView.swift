//
//  IconView.swift
//  Sapphire
//
//  Created by Kody Deda on 12/25/20.
//

import SwiftUI
import ComposableArchitecture
import Grid

struct AppView: View {
    var app: MacOSApplication
    
    var body: some View {
        VStack {            
            Image(app.icon)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .padding(.bottom, 4)
            
            Text(app.name)
                .font(.caption)
                .lineLimit(1)
        }
        .padding()
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(app: [MacOSApplication].allCases.first!)
    }
}
