//
//  MacOSApplication.swift
//  Sapphire
//
//  Created by Kody Deda on 12/24/20.
//

import SwiftUI
import ComposableArchitecture
import DynamicColor

struct MacOSApplication {
    struct State: Equatable, Identifiable, Codable {
        var id         : URL { url }
        let url        : URL
        let name       : String
        var icon       : URL
        var color      = CodableColor.init(color: .white)
        var selected   = false
        var customized = false
    }
    
    enum Action: Equatable {
        case toggleSelected
        case toggleCustom
        case modifyIconButtonTapped
        case updateColor(Color)
    }
}

extension MacOSApplication {
    static let reducer = Reducer<State, Action, Void>.combine(
        Reducer { state, action, _ in
            switch action {
            
            case .toggleSelected:
                return .none
                
            case .toggleCustom:
                state.customized.toggle()
                return .none
                
            case .modifyIconButtonTapped:
                return .none
                
            case let .updateColor(color):
                state.color = CodableColor(color: color)
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



