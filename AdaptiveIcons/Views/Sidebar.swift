//
//  SideBar.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/17/20.
//

import SwiftUI

struct Sidebar: View {
    var body: some View {
        List {            
            Text("Themes")
            Group{
                NavigationLink(destination: AppView()) {
                    Label("Default", systemImage: "square.grid.3x3")
                }
                NavigationLink(destination: ContentView()) {
                    Label("My Theme", systemImage: "folder")
                }
            }

            Spacer()
            Divider()
            
            NavigationLink(destination: AppView()) {
                Label("Settings", systemImage: "gear")
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Explore")
        
        //Set Sidebar Width (and height)
        .frame(minWidth: 200, idealWidth: 250, maxWidth: 300)
        .toolbar {
            //Toggle Sidebar Button
            ToolbarItem(placement: .primaryAction){
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.left")
                })
            }
        }
    }
}

func toggleSidebar() {
    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar), with: nil)
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}


