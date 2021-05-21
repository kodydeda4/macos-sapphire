//
//  MacOSApplicationSelectedView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/20/21.
//

import SwiftUI
import ComposableArchitecture

struct MacOSApplicationSelectedView: View {
    let store: Store<MacOSApplication.State, MacOSApplication.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                GroupBox {
                    Button(action: { viewStore.send(.toggleSelected) }) {
                    IconView(store: store)
                        .padding()
                        .frame(width: 125, height: 125)
                    }
                    .buttonStyle(PlainButtonStyle())
            }
            
            Text(viewStore.name)
                .font(.title)
                .bold()
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(height: 50)
                
                HStack {
                    Button(action: { viewStore.send(.updateColor(.blue) }) {
                        ZStack {
                            Circle()
                                .foregroundColor(.blue)
                                .frame(width: 15, height: 15)
                            Circle()
                                .frame(width: 6, height: 6)
                                .foregroundColor(Color.white.opacity(selection == color ? 1 : 0))
                                .shadow(color: Color.black.opacity(0.6), radius: 2)
                        }
                    }.buttonStyle(BorderlessButtonStyle())
                }

                
                Button(viewStore.customized ? "Remove Icon" : "Create Icon") {
                    viewStore.send(.modifyIconButtonTapped)
                }
            }
        }
    }
}

// MARK:- SwiftUI_Previews
struct MacOSApplicationSelectedView_Previews: PreviewProvider {
    static var previews: some View {
        MacOSApplicationSelectedView(store: MacOSApplication.defaultStore)
    }
}

