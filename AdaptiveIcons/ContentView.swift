//
//  ContentView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/15/20.
//

import SwiftUI

struct ContentView : View {
    @State var showRightPane = false
    @State var selectedApp = apps[0]
    
    var body: some View {
        NavigationView {
            Sidebar()
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button(
                            action: {},
                            label: { Text("Apply Theme") }
                        )
                    }
                    ToolbarItem(placement: .navigation) {
                        Button(
                            action: { withAnimation { self.showRightPane.toggle() } },
                            label:  { Image(systemName: "info.circle") }
                        )
                    }
                }
            
            
            HSplitView {
                AppGrid()
                if showRightPane {
                    InspectorPane(app: selectedApp)
                }
            }
        }.transition(.slide)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

let apps =
    try!
    FileManager
    .default
    .contentsOfDirectory(atPath: "/Applications")
    .filter { $0.contains(".app") && !$0.hasPrefix(".") }
    .map { CustomApp(path: "/Applications/\($0)" ) }
    .sorted(by: { $0.name < $1.name })




//struct AppView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppView()
//    }
//}
