//
//  AppsGrid.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/17/20.
//

import SwiftUI
import Grid

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
        
        Button(action: {
            print("plain")
        }) {
            VStack(alignment: .center, spacing: 6) {
                Image(contentsOfFile: app.defaultIconPath)?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 55, height: 55)
                
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

struct AppGrid_Previews: PreviewProvider {
    static var previews: some View {
        AppGrid()
    }
}


