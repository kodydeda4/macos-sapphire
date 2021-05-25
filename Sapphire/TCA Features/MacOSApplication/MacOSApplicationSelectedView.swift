//
//  MacOSApplicationSelectedView.swift
//  Sapphire
//
//  Created by Kody Deda on 5/20/21.
//

import SwiftUI
import ComposableArchitecture

struct MacOSApplicationSelectedView: View {
    let store: Store<MacOSApplication.State, MacOSApplication.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
//                GroupBox {
//                    Button(action: { viewStore.send(.toggleSelected) }) {
                        //                    IconView(store: store)
                        //                        .padding()
                        //                        .frame(width: 125, height: 125)
                        //                    }
                        //                    .buttonStyle(PlainButtonStyle())
                DropableImageFile(store: store)
//                    }
//                }
                
                Text(viewStore.name)
                    .font(.title)
                    .bold()
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(height: 50)
                
                Button(viewStore.modified ? "Remove Icon" : "Create Icon") {
                    viewStore.send(.modifyIconButtonTapped)
                }
            }
        }
    }
}

// MARK:- SwiftUI_Previews
struct MacOSApplicationSelectedView_Previews: PreviewProvider {
    static var previews: some View {
        MacOSApplicationSelectedView(store: MacOSApplication.defaultStore)
    }
}

import FetchImage

fileprivate struct FetchImageView2: View {
    let url: URL
    @StateObject private var image = FetchImage()

    var body: some View {
        ZStack {
            image.view?
                .resizable()
                .scaledToFit()
        }
        .onAppear { image.load(url) }
        .onChange(of: url) { image.load($0) }
        .animation(.default, value: url)
    }
}


struct DropableImageFile: View {
    @State private var flag = false
    @State private var url: URL? = nil
    
    let store: Store<MacOSApplication.State, MacOSApplication.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            
        
        Rectangle()
            .fill(self.flag ? Color.green : Color.gray)
            .overlay(Text("Drop Here"))
            .overlay(
                FetchImageView2(url: url ?? viewStore.icon)//viewStore.icon)
//                Image(nsImage: img ?? NSImage())
//                    .resizable()
//                    .frame(width: 150, height: 150)
            )
            .onDrop(of: ["public.file-url"], isTargeted: $flag, perform: { items in
                
                if let item = items.first {
                    item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                        if let urlData = urlData as? Data {
                            let u = NSURL.init(absoluteURLWithDataRepresentation: urlData, relativeTo: nil)
                            self.url = (u as URL)
                        }
                    }
                    return true
                } else {
                    return false
                }
            })
            .frame(width: 150, height: 150)
        }
    }
}
