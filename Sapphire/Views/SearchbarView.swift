//
//  SearchbarVuew.swift
//  Sapphire
//
//  Created by Kody Deda on 12/31/20.
//

import SwiftUI
import ComposableArchitecture
import Grid
import Combine

struct SearchbarView: View {
    @Binding var text: String
    @State var expanded = false
    
    var body: some View {
        if !expanded {
            Button(action: { expanded.toggle() }) {
                Image(systemName: "magnifyingglass")
            }
        } else {
            ZStack {
                TextField("Search", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack {
                    Spacer()
                    Button(
                        action: { text = ""; expanded = false },
                        label: { Image(systemName: "multiply.circle.fill") }
                    )
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.gray)
                }
                .padding(.horizontal, 6)
            }
            .frame(minWidth: 60, idealWidth: 200.0, maxWidth: 200.0)
        }
    }
}

// MARK:- SwiftUI Previews

struct SearchbarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchbarView(text: .constant(""), expanded: true)
        SearchbarView(text: .constant(""), expanded: false)
    }
}
