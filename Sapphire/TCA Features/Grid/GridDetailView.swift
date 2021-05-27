//
//  GridDetailView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import SwiftUI
import ComposableArchitecture

struct GridDetailView: View {
    let store: Store<Grid.State, Grid.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                if viewStore.macOSApplications.filter(\.selected).isEmpty {
                    Text("No Selection")
                        .font(.title)
                        .foregroundColor(Color(.disabledControlTextColor))
                    
                } else if viewStore.macOSApplications.filter(\.selected).count == 1 {
                    GroupBox {
                        
                        ZStack {
                            Image(systemName: "app.fill")
                                .resizable()
                                .scaledToFill()
                                .padding(5)
                                .foregroundColor(viewStore.selectedColor)
                                //.opacity(viewStore.selectedApp!.modified ? 1 : 0)
                            
                            FetchImageView(url: viewStore.selectedApp!.iconURL)
                                .padding(14)
                        }
                        .padding()
                        .frame(width: 125, height: 125)
                    }
                    
                    Text(viewStore.selectedApp!.name)
                        .font(.title)
                        .bold()
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .frame(height: 50)
                    
                    ColorSelectorView(selection: viewStore.binding(get: \.selectedColor, send: Grid.Action.updateSelectedColor))
                        .padding(.bottom)
                    
                    HStack {
                        Button("Reset") {
                            viewStore.send(.createResetIconsAlert)
                        }
                        .disabled(!viewStore.selectedApp!.modified)
                        Button("Apply") {
                            viewStore.send(.createSetIconsAlert)
                        }
                    }
                    
                } else {
                    Text("Multiple Selections")
                        .font(.title)
                    
                    Text("Not yet implemented")
                }
                Spacer()
            }
            .padding()
            .fixedSize()
        }
    }
}

// MARK:- SwiftUI_Previews
struct GridDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GridDetailView(store: Grid.defaultStore)
    }
}
