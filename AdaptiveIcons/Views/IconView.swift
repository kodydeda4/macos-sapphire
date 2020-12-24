//
//  IconView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI

struct IconView: View {
    var app: Model.App
    
    @State var isSelected = false
    //    @Binding var selectedIconViews: [IconView]
    
    var backgroundColor: Color { Color.accentColor.opacity(isSelected ? 1 : 0) }
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
            //                    if isSelected {
            //                        selectedIconViews.append(self)
            //                    } else {
            //                        selectedIconViews = Array(selectedIconViews.dropLast())
            //                    }
        }) {            
            VStack(alignment: .center, spacing: 3) {
                Image(contentsOfFile: app.defaultIconPath)?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 55, height: 55)
                    .padding(12)
                    .background(backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 3))

                Text(app.name)
                    .font(.system(size: 11, weight: .regular))
                    .multilineTextAlignment(.center)
                    .padding(3)
                    .clipShape(RoundedRectangle(cornerRadius: 3))
            }
//            .frame(width: 100, height: 100, alignment: .top)
            
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView(app: Model.App(path: "/Applications/Pages.app"))
    }
}


// MARK:- Extensions

extension Image {
    public init?(contentsOfFile: String) {
        guard let image = NSImage(contentsOfFile: contentsOfFile)
        else { return nil }
        self.init(nsImage: image)
    }
}

extension View {
    func clipShape(_ iconShape: IconShape?) -> some View {
        switch iconShape {
        
        case .roundedRectangle:
            return AnyView(self.clipShape(RoundedRectangle(cornerRadius: 10)))
            
        case .circle:
            return AnyView(self.clipShape(Circle()))
            
        default:
            return AnyView(self)
        }
    }
}

// MARK:- IconButton

enum IconShape: String, CaseIterable {
    case roundedRectangle = "Rounded Rectangle"
    case circle = "Circle"
}
