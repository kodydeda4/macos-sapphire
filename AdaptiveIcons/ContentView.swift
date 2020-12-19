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
            AppView()
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
        
        .frame(minWidth: 200, idealWidth: 250, maxWidth: 300)
        .toolbar {
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

// MARK:- AppView

struct AppView: View {
    @State var showRightPane = false
    @State var selectedApp = apps[0]

    var body: some View {
        HSplitView {
            grid
            if showRightPane {
                inspectorPane
            }
        }
    }
    
    var grid: some View {
        AppGrid()
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
    }
    
    var inspectorPane: some View {
        InspectorPane(app: selectedApp)
    }
    
}

// MARK:- AppGrid

struct AppGrid: View {
    var body: some View {
        ScrollView {
            Grid(apps) { AppGridCell(app: $0) }
                .padding(.all, 12)
            .gridStyle(
                ModularGridStyle(columns: .min(100), rows: .fixed(100))
            )
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
                .clipShape(Circle())
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

// MARK:- Image

extension Image {
    public init?(contentsOfFile: String) {
        guard let image = NSImage(contentsOfFile: contentsOfFile)
            else { return nil }
        self.init(nsImage: image)
    }
}



// MARK:- InspectorPane

struct InspectorPane: View {
    var app: CustomApp
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .center) {
                Spacer()
                Image(contentsOfFile: app.defaultIconPath)?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 55, height: 55)
                
                VStack {
                    HStack {
                        Text(app.name)
                            .font(.title2)
                    }
                    HStack(alignment: .top) {
                        Text("Path:")
                        Text(app.path)
                    }
                    HStack(alignment: .top) {
                        Text("Icon Path:")
                        Text(app.defaultIconPath)
                    }
                    
                }
                Spacer()

            }
            .padding(.all)
        }
        .frame(minWidth: 250, maxWidth: 250)
    }
}
