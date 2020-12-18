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
            AppGrid()
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Toggle(isOn: $showRightPane, label: {
                        Image(systemName: "info.circle")
                    })
                }
            }
            if showRightPane {
                InspectorPane(app: selectedApp)
            }
        }
    }
}




struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}


