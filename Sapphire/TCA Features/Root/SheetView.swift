//
//  SheetView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import SwiftUI
import ComposableArchitecture

struct SheetView: View {
    let store: Store<Grid.State, Grid.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if !viewStore.hasOnboarded {
                Onboarding(store: store)
            } else if viewStore.inFlight {
                ApplyingChanges()
            } else {
                Text("")
            }
        }
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(store: Grid.defaultStore)
    }
}

struct Onboarding: View {
    let store: Store<Grid.State, Grid.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
            Image("SapphireIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 90)

            Text("Welcome")
                .font(.title2)
                .fontWeight(.medium)
                .padding()
            
            Button("Continue") {
                viewStore.send(.completedOnboardingButtonTapped)
            }
        }
        .padding(30)
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        ApplyingChanges()
    }
}

struct ApplyingChanges: View {
    @State var opacity = true
    
    var body: some View {
        VStack {
            Image("SapphireIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 90)
            
            Text("Applying Changes")
                .font(.title2)
                .fontWeight(.medium)
                .padding()
            
        }
        .padding(30)
        .opacity(opacity ? 1 : 0)
        .animation(Animation.easeInOut(duration: 1).repeatForever(), value: opacity)
        .onAppear { opacity.toggle() }
    }
}

struct ApplyingChanges_Previews: PreviewProvider {
    static var previews: some View {
        ApplyingChanges()
    }
}
