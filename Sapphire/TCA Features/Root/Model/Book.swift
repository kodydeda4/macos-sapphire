//
//  Book.swift
//  Sapphire
//
//  Created by Kody Deda on 6/1/21.
//

import SwiftUI
import ComposableArchitecture
import Combine

import FirebaseFirestore
import FirebaseFirestoreSwift

/*------------------------------------------------------------------------------------------
 
 SwiftUI: Fetching Data from Firestore in Real Time (April 2020)
 https://peterfriese.dev/swiftui-firebase-fetch-data/
 
 
 SwiftUI: Mapping Firestore Documents using Swift Codable (May 2020)
 https://peterfriese.dev/swiftui-firebase-codable/
 
 Mapping Firestore Data in Swift
 https://peterfriese.dev/firestore-codable-the-comprehensive-guide/
 
 ------------------------------------------------------------------------------------------*/

// MARK:- Model

struct Book: Equatable, Identifiable, Codable {
    @DocumentID var id: String?
    @ServerTimestamp var createdAt: Date?
    var title: String
    var author: String
    var numberOfPages: Int
    var completed: Bool = false
}

struct BooksList {
    struct State: Equatable {
        var books = [Book]()
        var error: Firestore.DBError?
    }
    
    enum Action: Equatable {
        case onAppear
        
        case fetchBooks
        case addBook
        case removeBook(Book)
        case toggleCompleted(Book)

        case didFetchBooks(Result<[Book], Firestore.DBError>)
        case didAddBook(Result<Bool, Firestore.DBError>)
        case didRemoveBook(Result<Bool, Firestore.DBError>)
        
    }
    
    struct Environment {
        var db = Firestore.firestore()
        let books = "books"
    }
}

extension BooksList {
    static let reducer = Reducer<State, Action, Environment>.combine(

        Reducer { state, action, environment in
            switch action {
            
            case .onAppear:
                return Effect(value: .fetchBooks)
                
            case .fetchBooks:
                return environment.db
                    .fetchData(ofType: Book.self, from: environment.books)
                    .map(Action.didFetchBooks)
                    .receive(on: DispatchQueue.main)
                    .eraseToEffect()
                
            case .addBook:
                let book = Book.init(title: "Title", author: "Author", numberOfPages: 256)
                
                return environment.db.add(book, to: environment.books)
                    .map(Action.didAddBook)
                    .receive(on: DispatchQueue.main)
                    .eraseToEffect()
                
            case let .removeBook(book):
                return environment.db.remove(book.id!, from: environment.books)
                    .map(Action.didRemoveBook)
                    .receive(on: DispatchQueue.main)
                    .eraseToEffect()
                
            case let .toggleCompleted(book):
                var book2 = book
                book2.completed.toggle()
                
                environment.db.set(book.id!, to: book2, in: environment.books)
                return .none


            // Results
            case let .didFetchBooks(.success(books)):
                state.books = books
                return .none
                
            case .didAddBook    (.success),
                 .didRemoveBook (.success):
                
                return .none

            case let .didFetchBooks (.failure(error)),
                 let .didAddBook    (.failure(error)),
                 let .didRemoveBook (.failure(error)):
                
                state.error = error
                return .none
            }
        }
        .debug()
    )
}

extension BooksList {
    static let defaultStore = Store(
        initialState: .init(),
        reducer: reducer,
        environment: .init()
    )
}

// MARK:- BooksListView

struct BooksListView: View {
    let store: Store<BooksList.State, BooksList.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List(viewStore.books) { book in
                
                HStack {
                    Button(action: { viewStore.send(.toggleCompleted(book)) }) {
                        Image(systemName: book.completed ? "largecircle.fill.circle" : "circle")
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button("remove") { viewStore.send(.removeBook(book)) }

                    VStack(alignment: .leading) {
                        Text(book.title)
                            .font(.headline)
                        Text(book.author)
                            .font(.subheadline)
                        Text("\(book.numberOfPages) pages")
                            .font(.subheadline)
                    }
                    .foregroundColor(book.completed ? .gray : .primary)
                    
                }
            }
            .onAppear() {
                viewStore.send(.onAppear)
            }
            .toolbar {
                ToolbarItem {
                    Button("Add") { viewStore.send(.addBook) }
                }
                //                ToolbarItem {
                //                    Button("Clear Completed") {
                //                        viewStore.send(.clearCompleted)
                //                    }
                //                }
            }
        }
    }
}

struct BooksListView_Previews: PreviewProvider {
    static var previews: some View {
        BooksListView(store: BooksList.defaultStore)
    }
}
