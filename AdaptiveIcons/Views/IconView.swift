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
    var app: Model.App
            
    private func backgroundColor(_ viewStore: ViewStore<AppState, AppAction>) -> Color {
        Color.accentColor.opacity(isSelected(viewStore) ? 1 : 0)
    }

    private func isSelected(_ viewStore: ViewStore<AppState, AppAction>) -> Bool {
        viewStore.selectedAppIcons.contains(app)
    }
    
    var body: some View {
        iddlog("body \(app.name)")
        
        return WithViewStore(store) { viewStore in
            Button(action: {
                    iddlog("toggle \(app.name)")
                    viewStore.send(.toggle(app))
                }) {
                VStack(alignment: .center, spacing: 3) {
                    Image(nsImage: app.appIcon)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 55, height: 55)
                        .padding(12)
                        .background(backgroundColor(viewStore))
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                    
                    Text(app.name)
                        .font(.system(size: 11, weight: .regular))
                        .multilineTextAlignment(.center)
                        .padding(3)
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                }
                 .frame(width: 100, height: 100, alignment: .top)
            }
            .buttonStyle(BorderlessButtonStyle())
            .onAppear {
                iddlog("body \(app.name)")
            }
        }
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView(store: defaultStore, app: Model.App(path: "/Applications/Pages.app"))
    }
}
