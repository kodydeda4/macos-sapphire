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
                Spacer()
                Image("SapphireIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .shadow(radius: 1.5, y: 1)
                    .padding()
                
                Text("Welcome to Sapphire")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Adaptive macOS icons")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.top, 1)
                
                VStack(alignment: .leading) {
                    ForEach([
                        Feature(
                            name: "Find Recipes",
                            image: Image(systemName: "magnifyingglass"),
                            description: "Based on your ingredients"
                        ),
                        Feature(
                            name: "Save Favorites",
                            image: Image(systemName: "star"),
                            description: "All in one organized place"
                        ),
                        Feature(
                            name: "Learn Skills",
                            image: Image(systemName: "heart.text.square"),
                            description: "Develop culinary skills by cooking"
                        ),
                    ]) { feature in
                        HStack {
                            feature.image
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.blue)
                                .frame(width: 25)//, height: 36)
                                .padding(.trailing)
                            
                            VStack(alignment: .leading) {
                                Text(feature.name)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                Text(feature.description)
                                    //.font(.body)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                    }
                }
                .padding()
                
                Spacer()
                                
                Button("Continue") { viewStore.send(.completedOnboardingButtonTapped) }
                    .buttonStyle(RoundedRectangleButtonStyle(color: .blue))
            }
            .padding()
        }
    }
}

struct Feature: Identifiable, Equatable {
    var id = UUID()
    let name: String
    let image: Image
    let description: String
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
