//
//  InspectorPane.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/17/20.
//

import SwiftUI

struct InspectorPane: View {
    var app: CustomApp
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Image(contentsOfFile: app.defaultIconPath)?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 55, height: 55)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Name:")
                        Text(app.name)
                    }
                    HStack {
                        Text("Path:")
                        Text(app.path)
                    }
                    HStack {
                        Text("Icon Path:")
                        Text(app.defaultIconPath)
                    }
                    
                }

            }
            .padding(.all)
        }
        .frame(minWidth: 250, maxWidth: 250)
    }
}
struct InspectorPane_Previews: PreviewProvider {
    static var previews: some View {
        InspectorPane(app: apps[0])
    }
}
