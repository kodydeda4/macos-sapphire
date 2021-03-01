//
//  Sidebar.swift
//  Sapphire
//
//  Created by Kody Deda on 12/22/20.
//

import ComposableArchitecture
import SwiftUI

struct SidebarView: View {
    let store: Store<ThemeManager, ThemeManagerAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                List {
                    Section(header: Text("Icon Packs")) {
                        // Links
                    }
                    Section(header: Text("My Themes")) {
                        ForEachStore(
                            store.scope(
                                state: \.themes,
                                action: ThemeManagerAction.theme(index:action:))
                        ) { childStore in
                            WithViewStore(childStore) { childViewStore in
                                NavigationLink(destination: ThemeView(store: childStore)) {
                                    Text(childViewStore.name)
                                }
                                .navigationSubtitle(childViewStore.name)
                            }
                        }
                    }
                }
                Button(
                    action: { viewStore.send(.addThemeButtonTapped) },
                    label: { Label ("Add Theme", systemImage: "plus.circle") }
                )
                .buttonStyle(BorderlessButtonStyle())
                .padding(6)
            }
        }
        .listStyle(SidebarListStyle())
        .toolbar {
            ToolbarItem {
                Button(action: toggleSidebar) {
                    Image(systemName: "sidebar.left")
                }
            }
        }
    }
}


func toggleSidebar() {
    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar), with: nil)
}

// MARK:- SwiftUI Previews

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(store: ThemeManager.defaultStore)
    }
}
