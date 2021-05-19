//
//  GridDetailView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import SwiftUI
import ComposableArchitecture

struct GridDetailView: View {
    let store: Store<Root.State, Root.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                if viewStore.gridSelections.isEmpty {
                    Text("No Selection")
                        .font(.title)
                        .foregroundColor(Color(.disabledControlTextColor))
                    
                } else if viewStore.gridSelections.count == 1 {
                    GroupBox {
                        ImageView(url: viewStore.gridSelections.first!.icon)
                            .padding()
                            .frame(width: 125, height: 125)
                    }
                    
                    Text(viewStore.gridSelections.first!.name)
                        .font(.title)
                        .bold()
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .frame(height: 50)
                                        
                    Button("Create Icon") {
                        viewStore.send(.createIconButtonTapped)
                    }
                    
                } else {
                    GroupBox {
                        Image("SapphireLogo")
                            .resizable()
                            .scaledToFill()
                            .padding()
                            .frame(width: 125, height: 125)
                    }
                    
                    Text("Multiple Selections")
                        .font(.title)
                        .bold()
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .frame(height: 50)
                                        
                    Button("Create Icon") {
                        
                    }
                }
                Spacer()
            }
            .fixedSize()
            .toolbar {
                ToolbarItem {
                    Button<Image>("checkmark.circle") {
                        viewStore.send(.applyChanges)
                    }
                    .help("Apply Changes")
                }
            }
        }
    }
}

// MARK:- SwiftUI_Previews
struct GridDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GridDetailView(store: Root.defaultStore)
    }
}
