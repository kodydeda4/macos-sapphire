//
//  MacOSApplication.swift
//  Sapphire
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI
import ComposableArchitecture

struct MacOSApplication {
    struct State: Equatable, Identifiable, Hashable, Codable {
        var id         : URL { bundleURL }
        var bundleURL  : URL
        let name       : String
        var iconURL    : URL
        var colorHex      = "ffffff"
        var selected   = false
        var modified   = false
    }
    
    enum Action: Equatable {
        case toggleSelected
        case toggleCustom
        case modifyIconButtonTapped
    }
}

extension MacOSApplication {
    static let reducer = Reducer<State, Action, Void>.combine(
        Reducer { state, action, _ in
            switch action {
            
            case .toggleSelected:
                return .none
                
            case .toggleCustom:
                state.modified.toggle()
                return .none
                
            case .modifyIconButtonTapped:
                return .none
                
            }
        }
    )
}

extension MacOSApplication {
    static let defaultStore = Store(
        initialState: .init(
            bundleURL: Bundle.allBundleURLs.first!,
            name: Bundle.getName(from: Bundle.allBundleURLs.first!),
            iconURL: Bundle.getIcon(from: Bundle.allBundleURLs.first!)
        ),
        reducer: reducer,
        environment: ()
    )
}


extension Array where Element == MacOSApplication.State {
    
    /// Returns [MacOSApplication.State] containing all MacOSApplications.
    static var allCases: [MacOSApplication.State] {
        Bundle.allBundleURLs.map {
            MacOSApplication.State(
                bundleURL: $0,
                name: Bundle.getName(from: $0),
                iconURL: Bundle.getIcon(from: $0)
            )
        }
        .sorted(by: { $0.name < $1.name })
    }
}
