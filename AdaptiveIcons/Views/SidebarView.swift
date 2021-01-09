//
//  Sidebar.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/22/20.
//

import ComposableArchitecture
import SwiftUI

struct SidebarView: View {
//    let store: Store<RootState, RootAction>
    
    var body: some View {
//        WithViewStore(store.stateless) { viewStore in
            
            VStack(alignment: .leading) {
                List {
                    Section(header: Text("Icon Packs")) {}
                    Section(header: Text("My Themes")) {
//                        NavigationLink(
//                            destination: ThemeView(
//                                store: store.scope(
//                                    state: \.theme,
//                                    action: RootAction.theme)
//                            ).navigationTitle("Theme"),
//                            label: { Label("Theme", systemImage: "house")}
//                        )
                    }
                }
                .listStyle(SidebarListStyle())
                .frame(minWidth: 180, idealWidth: 250, maxWidth: 300)
                .toolbar {
                    ToolbarItem(placement: .primaryAction){
                        Button(action: toggleSidebar, label: {
                            Image(systemName: "sidebar.left")
                        })
                    }
                }
                HStack {
                    Button(action: {}, label: {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Add Theme")
                        }
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(6)
                }
            }
        }
//    }
}

func toggleSidebar() {
    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar), with: nil)
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
//        SidebarView(store: RootState.defaultStore)
        SidebarView()
    }
}
