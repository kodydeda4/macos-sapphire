//
//  ThemeViewModel.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/22/20.
//

import SwiftUI
import Grid

struct ThemeView: View {
    var theme: ThemeViewModel
    
    var body: some View {
        NavigationView {
            ThemePrimaryView(theme: theme)
            ThemeDetailView(theme: theme)
        }
    }
}

struct ThemePrimaryView: View {
    var theme: ThemeViewModel
    
    var body: some View {
        ScrollView {
            Grid(theme.icons) { icon in
                icon
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

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView(theme: themes[0])
    }
}

struct ThemeDetailView: View {
    let theme: ThemeViewModel
    
    var body: some View {
        VStack {
            Text(theme.name)s
        }
    }
}

//struct ThemeDetailView: View {
//    let iconPack: IconPackModel
//    @Binding var shape: IconView.IconShape
//    @Binding var color: Color
//    @Binding var iconShadow: Double
//    @Binding var shapeShadow: Double
//
//    var body: some View {
//        VStack {
//            IconView(app: apps[0], shape: shape, shapeColor: color, shapeShadow: shapeShadow, iconShadow: iconShadow)
//
//            VStack(alignment: .leading) {
//
//
//                Section(header: Text("Icon")) {
//                    Text("Icon Shadow")
//                    Slider(value: $iconShadow, in: 0...1, step: 0.1)
//
//                }
//                Divider()
//                Section(header: Text("Shape")) {
//                    Picker("", selection: $shape) {
//                        ForEach(IconView.IconShape.allCases, id: \.self) {
//                            Text($0.rawValue)
//                        }
//                    }
//                    Text("Shape Shadow")
//                    Slider(value: $shapeShadow, in: 0...1, step: 0.1)
//
//                    Text("Background Color")
//                    ColorPicker("", selection: $color)
//                }
//
//            }
//        }.padding()
//    }
//}
