//
//  OnboardingView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/25/21.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingView: View {
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
                                
                Button("Continue") { viewStore.send(.toggleOnboarding) }
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

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(store: Grid.defaultStore)
    }
}
