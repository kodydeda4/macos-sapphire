//
//  IconPackView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/22/20.
//

import SwiftUI
import Grid

struct IconPackView: View {
    var iconPack: IconPackModel
    
    var body: some View {
        NavigationView {
            IconPackPrimaryView(iconPack: iconPack)
            IconPackDetailView(iconPack: iconPack)
        }
    }
}

struct IconPackPrimaryView: View {
    var iconPack: IconPackModel
    
    var body: some View {
        ScrollView {
            Grid(iconPack.icons) { icon in
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

struct IconPackDetailView: View {
    var iconPack: IconPackModel
    
    var body: some View {
        VStack {
            Text(iconPack.name)
            Text(iconPack.description)
            
        }
    }
}
    

struct IconPackView_Previews: PreviewProvider {
    static var previews: some View {
        IconPackView(iconPack: iconPacks[0])
    }
}


