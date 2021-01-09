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
        VStack(alignment: .leading) {
            navigationLinks
            addThemeButton
        }
        .toolbar {
            ToolbarItem { toggleSidebarButton }
        }
    }
}

// MARK:- HelperViews

extension SidebarView {
    var navigationLinks: some View {
        List {
            Section(header: Text("Icon Packs")) {
                // Links
            }
            Section(header: Text("My Themes")) {
                themeNavigationLinks
            }
        }
        .listStyle(SidebarListStyle())
    }

    
    var themeNavigationLinks: some View {
        ForEachStore(
            store.scope(
                state: \.themes,
                action: ThemeManagerAction.theme(index:action:)))
        { childStore in
            WithViewStore(childStore) { childViewStore in
                NavigationLink(
                    destination: ThemeView(store: childStore)
                        .navigationSubtitle(childViewStore.description)
                ) {
                    HStack {
                        Image(systemName: "leaf.fill")
                        
                        TextField("Custom Theme",
                                  text: childViewStore.binding(
                                    get: \.description,
                                    send: ThemeAction.textFieldChanged)
                        )
                    }
                }
            }
        }
    }

    var addThemeButton: some View {
        WithViewStore(store.stateless) { viewStore in
            HStack {
                Button(action: { viewStore.send(.addThemeButtonTapped) }) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Add Theme")
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(6)
            }
        }
    }
    
    var toggleSidebarButton: some View {
        Button(
            action: toggleSidebar,
            label: { Image(systemName: "sidebar.left") }
        )
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
