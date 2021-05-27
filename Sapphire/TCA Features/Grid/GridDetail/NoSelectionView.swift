//
//  NoSelectionView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/27/21.
//

import SwiftUI

struct NoSelectionView: View {
    var body: some View {
        VStack {
            Text("No Selection")
                .font(.title)
                .foregroundColor(Color(.disabledControlTextColor))
        }
    }
}

struct NoSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NoSelectionView()
    }
}
