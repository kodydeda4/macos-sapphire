//
//  SearchbarVuew.swift
//  AdaptiveIcons
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
        if expanded {
            expandedView
        } else {
            compactView
        }
    }
}

extension SearchbarView {
    var compactView: some View {
        Button(action: { expanded.toggle() }) {
            Image(systemName: "magnifyingglass")
        }
    }
}

extension SearchbarView {
    var expandedView: some View {
        ZStack {
            textfield
            cancelButton
        }
        .frame(minWidth: 60, idealWidth: 200.0, maxWidth: 200.0)
    }
    
    var textfield: some View {
        TextField("Search", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    
    var cancelButton: some View {
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
}


struct SearchbarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchbarView(text: .constant(""), expanded: true)
        SearchbarView(text: .constant(""), expanded: false)
    }
}
