import Foundation

struct CustomApp: Identifiable {

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
        if let infoPlistPath = Optional(URL(fileURLWithPath: "\(path)/Contents/Info.plist")) {
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


let apps =
    try!
    FileManager
    .default
    .contentsOfDirectory(atPath: "/Applications")
    .filter { $0.contains(".app") && !$0.hasPrefix(".") }
    .map { CustomApp(path: "/Applications/\($0)" ) }




    

// of course it can't detect apps inside folders such as Photoshop:  /Applications/Adobe Photoshop 2021/Adobe Photoshop 2021.app/Contents/Resources/PS_AppIcon.icns

for a in apps {
    print(a.defaultIconPath)
}
