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
            //Caption
            Text("Services")
            
            //Navigation links
            Group{
                NavigationLink(destination: AppView()) {
                    Label("Apps", systemImage: "square.grid.3x3")
                }
                NavigationLink(destination: AppView()) {
                    Label("Weather", systemImage: "cloud.sun")
                }
                NavigationLink(destination: AppView()) {
                    Label("Charge", systemImage: "bolt.car")
                }
                NavigationLink(destination: AppView()) {
                    Label("HealthCare", systemImage: "pills")
                }
                NavigationLink(destination: AppView()) {
                    Label("Ticket", systemImage: "ticket")
                }
                NavigationLink(destination: AppView()) {
                    Label("Calculator", systemImage: "function")
                }
            }
            
            Spacer()
            
            Text("More")
            NavigationLink(destination: AppView()) {
                Label("Shortcut", systemImage: "option")
            }
            NavigationLink(destination: AppView()) {
                Label("Customize", systemImage: "slider.horizontal.3")
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


