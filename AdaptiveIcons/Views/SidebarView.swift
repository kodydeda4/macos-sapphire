//
//  Sidebar.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/22/20.
//

import ComposableArchitecture
import SwiftUI

struct SidebarView: View {
    let store: Store<RootState, RootAction>
    
    var body: some View {
        navigationLinksList
        .toolbar {
            ToolbarItem { toggleSidebarButton }
        }
        addThemeButton
    }
}

// MARK:- HelperViews

extension SidebarView {
    var navigationLinksList: some View {
        VStack(alignment: .leading) {
            List {
                Section(header: Text("Icon Packs")) {
                    // Links
                }
                Section(header: Text("My Themes")) {
                    // Links
                }
            }
            .listStyle(SidebarListStyle())
        }
    }
    
    var toggleSidebarButton: some View {
        Button(
            action: toggleSidebar,
            label: { Image(systemName: "sidebar.left") }
        )
    }
    
    var addThemeButton: some View {
        HStack {
            Button(action: {}) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Add Theme")
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(6)
            Spacer()
        }
    }
}

func toggleSidebar() {
    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar), with: nil)
}

// MARK:- SwiftUI Previews

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(store: RootState.defaultStore)
    }
}
