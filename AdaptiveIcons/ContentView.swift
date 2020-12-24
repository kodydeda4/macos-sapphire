//
//  ContentView.swift
//  AdaptiveIcons
//
//  Created by Kody Deda on 12/15/20.
//

import SwiftUI
import Grid

// MARK:- ContentView

struct ContentView: View {
    @State var selectedIconViews: [IconButtonView] = []
    
    var body: some View {
        NavigationView {
            List {}
            ThemePrimaryView(selectedIconViews: $selectedIconViews)
            ThemeDetailView(selectedIconViews: $selectedIconViews)
        }
        .frame(width: 1920/2, height: 1080/2)
    }
}

struct ThemePrimaryView: View {
    @Binding var selectedIconViews: [IconButtonView]

    var body: some View {
        ScrollView {
            Grid(apps) { icon in
                IconButtonView(app: icon, selectedIconViews: $selectedIconViews)
            }.padding(16)
        }
    }
}

struct ThemeDetailView: View {
    @Binding var selectedIconViews: [IconButtonView]

    var body: some View {
        ScrollView {
            Grid(selectedIconViews) { iconView in
                iconView
            }.padding(16)
        }
    }
}


struct IconButtonView: View, Identifiable {
    var id = UUID()
    var app: AppModel

    @State var isSelected = false
    @Binding var selectedIconViews: [IconButtonView]

    var backgroundColor: Color { Color.accentColor.opacity(isSelected ? 1 : 0) }

    var body: some View {
        Button(action: {
                    isSelected.toggle()
                    if isSelected {
                        selectedIconViews.append(self)
                    } else {
                        selectedIconViews = Array(selectedIconViews.dropLast())
                    }
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
            .frame(width: 100, height: 100, alignment: .top)

        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

extension Image {
    public init?(contentsOfFile: String) {
        guard let image = NSImage(contentsOfFile: contentsOfFile)
        else { return nil }
        self.init(nsImage: image)
    }
}

// MARK:- Extensions

enum IconShape: String, CaseIterable {
    case roundedRectangle = "Rounded Rectangle"
    case circle = "Circle"
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK:- Apps

let apps =
    try!
    FileManager
    .default
    .contentsOfDirectory(atPath: "/Applications")
    .filter { $0.contains(".app") && !$0.hasPrefix(".") }
    .map { AppModel(path: "/Applications/\($0)" ) }
    .sorted(by: { $0.name < $1.name })


struct AppModel: Identifiable {
    enum IconState {
        case normal
        case adaptive
        case custom
    }
    
    let id = UUID()
    let path: String
    let iconState: IconState
    
    init(path: String) {
        self.path = path
        self.iconState = .normal
    }
    
    var name: String {
        path
        .replacingOccurrences(of: "/Applications/", with: "")
        .replacingOccurrences(of: ".app", with: "")
    }
    
    var defaultIconPath: String {
        let rv = "\(path)/Contents/Resources/\(AppBundlePlist?["CFBundleIconFile"] ?? AppBundlePlist?["Icon file"] ?? "AppIcon")"
        return rv.contains(".icns")
            ? rv
            : rv + ".icns"
    }
    
    var description: String { "AnApp<\(name)> \n path: \(path), \n defaultIconPath: \(defaultIconPath)" }
    
    var AppBundlePlist: [String: Any]? {
        if let infoPlistPath = try? URL(fileURLWithPath: "\(path)/Contents/Info.plist") {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)
                
                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any] {
                    return dict
                }
            } catch {
                print(error)
            }
        }
        return ["":""]
    }
}
