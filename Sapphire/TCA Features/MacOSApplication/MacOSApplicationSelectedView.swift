//
//  MacOSApplicationSelectedView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/20/21.
//

import SwiftUI

struct MacOSApplicationSelectedView: View {
    let application: MacOSApplication.State
    
    var body: some View {
        VStack {
            GroupBox {
                FetchImageView(url: application.iconURL)
                    .padding()
                    .frame(width: 125, height: 125)
            }
        }
        
        Text(application.name)
            .font(.title)
            .bold()
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .frame(height: 50)
    }
}

// MARK:- SwiftUI_Previews
struct MacOSApplicationSelectedView_Previews: PreviewProvider {
    static var previews: some View {
        MacOSApplicationSelectedView(application: [MacOSApplication.State].allCases.first!)
    }
}

