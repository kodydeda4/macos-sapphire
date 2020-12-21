//
//  ContentView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/15/20.
//

import SwiftUI
import Grid

struct ContentView : View {
    @State var showRightPane = false
    
    var body: some View {
        NavigationView {
            sidebar
            primaryView
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button(
                            action: {},
                            label: { Text("Apply Theme") }
                        )
                    }
                    ToolbarItem(placement: .automatic) {
                        Button(
                            action: { self.showRightPane.toggle() },
                            label:  { Image(systemName: "info.circle") }
                        )
                    }
                }
            showRightPane
                ? DetailView()
                    .transition(.move(edge: .trailing))
                    .animation(.easeIn)
                : nil
        }
    }
    
    var sidebar = Sidebar()
    var primaryView = PrimaryView()
    var detailView = DetailView()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK:- Sidebar

struct Sidebar: View {
    let themes = [
        NavigationLink(destination: PrimaryView()) { Label("My Theme", systemImage: "folder") },
        NavigationLink(destination: PrimaryView()) { Label("My Theme", systemImage: "folder") },
        NavigationLink(destination: PrimaryView()) { Label("My Theme", systemImage: "folder") },
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section(header: Text("Icon Pack")) {
                    NavigationLink(destination: PrimaryView()) {
                        Label("Default", systemImage: "square.grid.3x3")
                    }
                }
                
                Section(header: Text("My Themes")) {
                    Group {
                        ForEach(0 ..< 3) { _ in
                            NavigationLink(destination: PrimaryView()) {
                                Label("My Theme", systemImage: "folder")
                            }
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
    @State var selectedApp = apps[0]

    var body: some View {
        AppGrid()
    }
}

struct AppGrid: View {
    
    @State var selectedApp = apps[0]

    var body: some View {
        ScrollView {
            Grid(apps) {
                AppGridCell(app: $0)
            }
            .padding(.all, 12)
            .gridStyle(ModularGridStyle(columns: .min(100), rows: .fixed(100)))
        }
        .layoutPriority(1)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct AppGridCell: View {
    let app: CustomApp
    
    var body: some View {
        
        Button(action: {}) {
            VStack(alignment: .center, spacing: 6) {
                ZStack {
                    Color.white
                    Image(contentsOfFile: app.defaultIconPath)?
                        .resizable()
                        .scaledToFill()
                        .padding(4)
                }
                .frame(width: 55, height: 55)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: Color.black.opacity(0.2), radius: 1, y: 1)
                
                Text(app.name)
                    .font(.system(size: 11, weight: .regular))
                    .multilineTextAlignment(.center)
                    .frame(width: 90, height: 30, alignment: .top)
            }
            .frame(width: 100, height: 100)
        }.buttonStyle(BorderlessButtonStyle())
    }
}

extension Image {
    public init?(contentsOfFile: String) {
        guard let image = NSImage(contentsOfFile: contentsOfFile)
            else { return nil }
        self.init(nsImage: image)
    }
}

// MARK:- DetailView

struct DetailView: View {
    
    var body: some View {
        ScrollView {
            Text("DetailView")
        }
        .padding(.all)
//        .frame(minWidth: 250, maxWidth: 250)
    }
}


