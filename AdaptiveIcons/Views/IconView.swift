//
//  IconView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/25/20.
//

import SwiftUI
import Combine
import ComposableArchitecture
import Grid

struct IconView: View {
    let store: Store<AppState, AppAction>
    var icon: Icon
            
    private func selectionColor(_ viewStore: ViewStore<AppState, AppAction>) -> Color {
        Color.accentColor.opacity(isSelected(viewStore) ? 1 : 0)
    }

    private func isSelected(_ viewStore: ViewStore<AppState, AppAction>) -> Bool {
        viewStore.icons.filter(\.isSelected).contains(icon)
    }
    
    var body: some View {
        iddlog("body \(icon.name)")
        
        return WithViewStore(store) { viewStore in
            Button(action: {
                    iddlog("toggle \(icon.name)")
                    viewStore.send(.toggleSelection(icon))
                }) {
                
                VStack(alignment: .center, spacing: 3) {
                    Image(nsImage: icon.appIcon)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .padding(8)
                        //.background(backgroundColor(viewStore))
                        .background(icon.background)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: Color.black.opacity(0.25), radius: 1.6, y: 2.0)
                    
                    Text(icon.name)
                        .font(.system(size: 11, weight: .regular))
                        .multilineTextAlignment(.center)
                        .padding(3)
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                }
                
                .frame(width: 100, height: 100, alignment: .top)
            }
            .border(selectionColor(viewStore))
            .buttonStyle(BorderlessButtonStyle())
            .onAppear {
                iddlog("body \(icon.name)")
            }
        }
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView(store: defaultStore, icon: Icon(path: "/Applications/Pages.app"))
    }
}
