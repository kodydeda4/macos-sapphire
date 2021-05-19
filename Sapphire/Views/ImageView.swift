//
//  ImageView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import SwiftUI
import FetchImage

struct ImageView: View {
    let url: URL
    @StateObject private var image = FetchImage()

    var body: some View {
        ZStack {
            image.view?
                .resizable()
                .scaledToFill()
                .clipped()
        }
        .onAppear { image.load(url) }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(url: Bundle.allBundleURLs.first!)
    }
}

