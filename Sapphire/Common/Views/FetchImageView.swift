//
//  MacOSApplicationIconView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/20/21.
//

import SwiftUI
import ComposableArchitecture

// MARK:- FetchImageView
// Loads images really fast.

import FetchImage

struct FetchImageView: View {
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
    .animation(.default, value: url)
  }
}
