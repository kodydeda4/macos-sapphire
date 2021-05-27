//
//  SelectedMacOSApplicationView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/27/21.
//

import SwiftUI
import ComposableArchitecture

struct SelectedMacOSApplicationView: View {
    let store: Store<MacOSApplication.State, MacOSApplication.Action>
    @Binding var color: Color
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                GroupBox {
                    ZStack {
                        Image(systemName: "app.fill")
                            .resizable()
                            .scaledToFill()
                            .padding(5)
                            .foregroundColor(color)
                        
                        FetchImageView(url: viewStore.iconURL)
                            .padding(14)
                    }
                    .padding()
                    .frame(width: 125, height: 125)
                }
                .padding()
                
                Text(viewStore.name)
                    .font(.title3)
                    .bold()
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
            }
        }
    }
}

struct SelectedMacOSApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedMacOSApplicationView(store: MacOSApplication.defaultStore, color: .constant(.white))
    }
}


