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

        case didFetchBooks (Result<[Book], Firestore.DBError>)
        case didAddBook    (Result<Bool,   Firestore.DBError>)
        case didRemoveBook (Result<Bool,   Firestore.DBError>)
        case didUpdateBook (Result<Bool,   Firestore.DBError>)
    }
    
    struct Environment {
        let db = Firestore.firestore()
        let collection = "books"
        
        var fetchData: Effect<Action, Never> {
            db.fetchData(ofType: Book.self, from: collection)
                .map(Action.didFetchBooks)
                .eraseToEffect()
        }
        
        func addBook(_ book: Book) -> Effect<Action, Never> {
            db.add(book, to: collection)
                .map(Action.didAddBook)
                .eraseToEffect()
        }
        
        func removeBook(_ book: Book) -> Effect<Action, Never> {
            db.remove(book.id!, from: collection)
                .map(Action.didRemoveBook)
                .eraseToEffect()
        }
        
        func updateBook(_ oldBook: Book, to newBook: Book) -> Effect<Action, Never> {
            db.set(oldBook.id!, to: newBook, in: collection)
                .map(Action.didUpdateBook)
                .eraseToEffect()
        }
    }
}

extension BooksList {
    static let reducer = Reducer<State, Action, Environment>.combine(
        
        Reducer { state, action, environment in
            switch action {
            
            case .onAppear:
                return Effect(value: .fetchBooks)
                
            case .fetchBooks:
                return environment.fetchData
                
            case .addBook:
                return environment.addBook(Book(title: "Title", author: "Author", numberOfPages: 256))
                
            case let .removeBook(book):
                return environment.removeBook(book)
                
            case let .toggleCompleted(book):
                var book2 = book
                book2.completed.toggle()
                
                return environment.updateBook(book, to: book2)

            // Result
            case let .didFetchBooks(.success(books)):
                state.books = books
                return .none
                
            case .didAddBook        (.success),
                 .didRemoveBook     (.success),
                 .didUpdateBook     (.success):
                return .none

            case let .didFetchBooks (.failure(error)),
                 let .didAddBook    (.failure(error)),
                 let .didRemoveBook (.failure(error)),
                 let .didUpdateBook (.failure(error)):
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
                    .opacity(book.completed ? 0.25 : 1)
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
