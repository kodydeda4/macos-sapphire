//
//  Root.swift
//  Sapphire
//
//  Created by Kody Deda on 5/31/21.
//

import SwiftUI
import ComposableArchitecture
import Firebase


// MARK:- Setup

struct UserAuthentication {
    struct State: Equatable {
        var email = ""
        var password = ""
    }
    
    enum Action: Equatable {
        case updateEmail(String)
        case updatePassword(String)
        case loginButtonTapped
    }
    
    struct Environment {
        // environment
    }
}

extension UserAuthentication {
    static let reducer = Reducer<State, Action, Environment>.combine(
        // pullbacks
        Reducer { state, action, environment in
            switch action {
            
            case let .updateEmail(value):
                state.email = value
                return .none
                
            case let .updatePassword(value):
                state.password = value
                return .none
                
            case .loginButtonTapped:
                Auth.auth().signIn(withEmail: state.email, password: state.password) { result, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("success")
                    }
                }
                return .none
            }
        }
    )
}

extension UserAuthentication {
    static let defaultStore = Store(
        initialState: .init(),
        reducer: reducer,
        environment: .init()
    )
}

// MARK:- RootView

struct UserAuthenticationView: View {
    let store: Store<UserAuthentication.State, UserAuthentication.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                VStack {
                TextField("Email", text: viewStore.binding(get: \.email, send: UserAuthentication.Action.updateEmail))
                TextField("Password", text: viewStore.binding(get: \.password, send: UserAuthentication.Action.updatePassword))
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Login") {
                        viewStore.send(.loginButtonTapped)
                    }
                }
            }
        }
    }
}

struct UserAuthentication_Previews: PreviewProvider {
    static var previews: some View {
        UserAuthenticationView(store: UserAuthentication.defaultStore)
    }
}
