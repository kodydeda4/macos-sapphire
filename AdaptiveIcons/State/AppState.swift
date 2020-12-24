//
//  AppState.swift
//  AdaptiveIcons
//
//  Created by Klajd Deda on 12/24/20.
//

import Combine
import ComposableArchitecture
import SwiftUI

// MARK: - AppState

struct AppState: Equatable {
    var appIcons = [Model.App]()
}

// MARK: - AppAction

enum AppAction {
    case loadIcons
}

// MARK: - AppEnvironment

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
}

let defaultStore = Store(
    initialState: AppState(),
    reducer: appReducer,
    environment: AppEnvironment(
        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
        uuid: UUID.init
    )
)

// MARK: - Reducer (AppState, AppAction)
let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    Reducer { state, action, environment in
        iddlog("action: '\(action)'")

        switch action {
            case .loadIcons:
                let appIcons = try? FileManager
                    .default
                    .contentsOfDirectory(atPath: "/Applications")
                    .filter { $0.contains(".app") && !$0.hasPrefix(".") }
                    .map { Model.App(path: "/Applications/\($0)" ) }
                    .sorted(by: { $0.name < $1.name })

                state.appIcons = appIcons ?? [Model.App]()
                return .none
        }
    }
)
