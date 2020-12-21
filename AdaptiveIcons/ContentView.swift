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
                Section(header: Text("Icon Packs")) {
                    ForEach(iconPacks) { iconPack in
                        NavigationLink(destination: PrimaryView(iconPack: iconPack)) {
                            Label(iconPack.name, systemImage: iconPack.imageName)
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
            Grid(apps) { app in
                Icon(app: app)
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
    
    @State private var selectedShape = 0
    var shapes = ["Rounded Rectangle", "Circle"]
    
    @State private var selectedIconPack = 0
    var iconPack = ["Default"]
    
    @State var adaptiveIcons: Bool = false
    @State private var selectedColor = Color.white

    var body: some View {
        ScrollView {
            VStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(width: 200, height: 200)
                    .foregroundColor(selectedColor)
                
                Form {
                    Section(header: Text("Icon Pack")) {
                        Picker("", selection: $selectedIconPack) {
                            ForEach(0 ..< iconPack.count) {
                                Text(self.iconPack[$0])
                            }
                        }
                        Spacer()
                        Toggle(isOn: $adaptiveIcons) {
                            Text("Adaptive Shape")
                        }
                        Spacer()
                        Picker("", selection: $selectedShape) {
                            ForEach(0 ..< shapes.count) {
                                Text(self.shapes[$0])
                            }
                        }.disabled(!adaptiveIcons)
                        Spacer()
                        Text("Color")
                        ColorPicker("", selection: $selectedColor)
                        Spacer()
                    }
                }.padding()
            }
        }
        .padding()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
