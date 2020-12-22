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
//            DetailView()
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
    @State private var shape = Icon.IconShape.roundedRectangle
    @State private var color = Color.white

    var body: some View {
        NavigationView {
            ScrollView {
                Grid(apps) { app in
                    Icon(app: app, shape: shape, bgColor: color)
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
            VStack {
                Icon(app: apps[0], shape: shape, bgColor: color)
                Picker("Shape", selection: $shape) {
                    ForEach(Icon.IconShape.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                ColorPicker("", selection: $color)
            }.padding()
        }
    }
}

//


struct Icon: View {
    let app: CustomApp
    
    enum IconShape: String, CaseIterable {
        case roundedRectangle = "Rounded Rectangle"
        case circle = "Circle"
    }
    
    var shape: IconShape
    var bgColor: Color
    

    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            ZStack {
                getShape(shape: shape)
                    .foregroundColor(bgColor)
                iconImage
                    .shadow(color: Color.black.opacity(0.2), radius: 1, y: 1)
            }
            .frame(width: 55, height: 55)
            iconName
        }
        .frame(width: 100, height: 100)
    }
    
    var iconImage: some View {
        Image(contentsOfFile: app.defaultIconPath)?
            .resizable()
            .scaledToFill()
            .padding(4)

    }
    
    var iconName: some View {
        Text(app.name)
            .font(.system(size: 11, weight: .regular))
            .multilineTextAlignment(.center)
            .frame(width: 90, height: 30, alignment: .top)
    }


    func getShape(shape: IconShape) -> some View {
        switch shape {
        case .roundedRectangle:
            return AnyView(RoundedRectangle(cornerRadius: 10))
        case .circle:
            return AnyView(Circle())
        }
    }
}

struct BasicViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        return content
    }
}


extension Image {
    public init?(contentsOfFile: String) {
        guard let image = NSImage(contentsOfFile: contentsOfFile)
            else { return nil }
        self.init(nsImage: image)
    }
}

struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        Icon(app: apps[0], shape: .roundedRectangle, bgColor: .white)
    }
}
