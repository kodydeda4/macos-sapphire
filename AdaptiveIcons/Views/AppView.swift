//
//  AppScrollView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/17/20.
//

import SwiftUI



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

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
