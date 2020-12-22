//
//  ThemeView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/22/20.
//

import SwiftUI
import Grid

struct ThemeView: View {
    let iconPack: IconPackModel

    @State var iconShadow: Double = 0.2
    
    @State var shape = IconView.IconShape.roundedRectangle
    @State var shapeColor = Color.white
    @State var shapeShadow: Double = 0.2
    

    var body: some View {
        NavigationView {
            AppGridView(iconPack: iconPack, shape: $shape, color: $shapeColor, iconShadow: $iconShadow, shapeShadow: $shapeShadow)
                .frame(minWidth: 500)
            IconCustomizeView(iconPack: iconPack, shape: $shape, color: $shapeColor, iconShadow: $iconShadow, shapeShadow: $shapeShadow)
                .frame(width: 250)
        }
    }
}

struct AppGridView: View {
    let iconPack: IconPackModel
    @Binding var shape: IconView.IconShape
    @Binding var color: Color
    @Binding var iconShadow: Double
    @Binding var shapeShadow: Double
    
    var body: some View {
        ScrollView {
            Grid(apps) { app in
                IconView(app: app, shape: shape, shapeColor: color, shapeShadow: shapeShadow, iconShadow: iconShadow)
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

struct IconCustomizeView: View {
    let iconPack: IconPackModel
    @Binding var shape: IconView.IconShape
    @Binding var color: Color
    @Binding var iconShadow: Double
    @Binding var shapeShadow: Double
    
    var body: some View {
        VStack {
            IconView(app: apps[0], shape: shape, shapeColor: color, shapeShadow: shapeShadow, iconShadow: iconShadow)
            
            VStack(alignment: .leading) {
                

                Section(header: Text("Icon")) {
                    Text("Icon Shadow")
                    Slider(value: $iconShadow, in: 0...1, step: 0.1)
                    
                }
                Divider()
                Section(header: Text("Shape")) {
                    Picker("", selection: $shape) {
                        ForEach(IconView.IconShape.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    Text("Shape Shadow")
                    Slider(value: $shapeShadow, in: 0...1, step: 0.1)
                    
                    Text("Background Color")
                    ColorPicker("", selection: $color)
                }

            }
        }.padding()
    }
}


struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView(iconPack: iconPacks[0])
    }
}
