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
    @State var shape = IconView.IconShape.roundedRectangle
    @State var color = Color.white

    var body: some View {
        NavigationView {
            AppGridView(iconPack: iconPack, shape: $shape, color: $color)
            IconCustomizeView(iconPack: iconPack, shape: $shape, color: $color)
        }
    }
}

struct AppGridView: View {
    let iconPack: IconPackModel
    @Binding var shape: IconView.IconShape
    @Binding var color: Color
    
    var body: some View {
        ScrollView {
            Grid(apps) { app in
                IconView(app: app, shape: shape, bgColor: color)
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
    
    var body: some View {
        VStack {
            IconView(app: apps[0], shape: shape, bgColor: color).foregroundColor(color)
            
            Picker("Shape", selection: $shape) {
                ForEach(IconView.IconShape.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            ColorPicker("", selection: $color)
        }.padding()
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView(iconPack: iconPacks[0])
    }
}
