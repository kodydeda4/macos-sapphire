//
//  ContentView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/15/20.
//

import SwiftUI
import Grid

struct ContentView : View {
    var body: some View {
        NavigationView {
            Sidebar()
            PrimaryView(iconPack: iconPacks[0])
            DetailView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK:- Sidebar

struct Sidebar: View {
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section(header: Text("Icon Pack")) {
                    ForEach(iconPacks) { iconPack in
                        NavigationLink(destination: PrimaryView(iconPack: iconPack)) {
                            Label(iconPack.name, systemImage: "square.grid.3x3")
                        }
                    }
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
}

func toggleSidebar() {
    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar), with: nil)
}

// MARK:- PrimaryView

struct PrimaryView: View {
    let iconPack: IconPack

    var body: some View {
        ScrollView {
            Grid(apps) {
                Icon(app: $0, theme: iconPack.iconTheme)
            }
            .padding(.all, 12)
            .gridStyle(ModularGridStyle(columns: .min(100), rows: .fixed(100)))
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(
                    action: {},
                    label: { Text("Apply Theme") }
                )
            }
        }
    }
}


// MARK:- DetailView

struct DetailView: View {
    var body: some View {
        Text("Editor")

    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
