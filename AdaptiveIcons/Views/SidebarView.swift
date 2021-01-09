//
//  Sidebar.swift
//  AdaptiveIcons
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
                                action: ThemeManagerAction.theme(index:action:)),
                            content: NavLink.init
                        )
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

// MARK:- HelperViews

struct NavLink: View {
    var store: Store<ThemeState, ThemeAction>
    
    init(_ store: Store<ThemeState, ThemeAction>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationLink(destination: ThemeView(store: store)) {
                HStack {
                    Image(systemName: "leaf.fill")
                    TextField("Custom Theme", text: viewStore.binding(
                                get: \.description,
                                send: ThemeAction.textFieldChanged))
                    
                }
            }
            .navigationSubtitle(viewStore.description)
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
