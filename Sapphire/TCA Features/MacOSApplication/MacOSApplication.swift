//
//  MacOSApplication.swift
//  Sapphire
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI
import ComposableArchitecture

struct MacOSApplication {
    struct State: Equatable, Identifiable, Hashable {
        var id   : URL { url }
        let url  : URL
        let name : String
        let icon : URL
        var selected   = false
        var customIcon = false
    }
    
    enum Action: Equatable {
        case toggleSelected
        case toggleCustom
        case createIconButtonTapped
    }
}

extension MacOSApplication {
    static let reducer = Reducer<State, Action, Void>.combine(
        Reducer { state, action, _ in
            switch action {
            
            case .toggleSelected:
                //state.selected.toggle()
                return .none
                
            case .toggleCustom:
                state.customIcon.toggle()
                return .none
                
            case .createIconButtonTapped:
                print("foo")
                return .none
            }
        }
    )
}

extension MacOSApplication {
    static let defaultStore = Store(
        initialState: .init(
            url: Bundle.allBundleURLs.first!,
            name: Bundle.name(from: Bundle.allBundleURLs.first!),
            icon: Bundle.icon(from: Bundle.allBundleURLs.first!)
        ),
        reducer: reducer,
        environment: ()
    )
}



