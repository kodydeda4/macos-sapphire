//
//  AppScrollView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/17/20.
//

import SwiftUI

let apps =
    try!
    FileManager
    .default
    .contentsOfDirectory(atPath: "/Applications")
    .filter { $0.contains(".app") && !$0.hasPrefix(".") }
    .map { CustomApp(path: "/Applications/\($0)" ) }
    .sorted(by: { $0.name < $1.name })


struct AppView: View {
    @State var showRightPane = true
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
                    action: { withAnimation { self.showRightPane.toggle() } },
                    label:  { Image(systemName: "info.circle") }
                )
            }
        }
    }
    
    var inspectorPane: some View {
        InspectorPane(app: selectedApp)
            .transition(.slide)
    }
    
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}


