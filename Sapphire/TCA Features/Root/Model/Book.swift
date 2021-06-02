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

// MARK:- TCA

struct BooksList {
    struct State: Equatable {
        var books = [Book]()
        var error: Firestore.DBError?
    }
    
    enum Action: Equatable {
        case onAppear
        case fetchBooks
        case fetchBooksResult(Result<[Book], Firestore.DBError>)
        case addBook
        case removeBook(Book)
        case toggleCompleted(Book)
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
                    .map(Action.fetchBooksResult)
                    .receive(on: DispatchQueue.main)
                    .eraseToEffect()

            case let .fetchBooksResult(.success(books)):
                state.books = books
                return .none
                
            case let .fetchBooksResult(.failure(error)):
                state.error = error
                return .none
                
            case .addBook:
                let book = Book.init(title: "Title", author: "Author", numberOfPages: 256)

                environment.db.add(book, to: environment.books)
                return .none
                
            case let .removeBook(book):
                environment.db.remove(book.id!, from: environment.books)
                return .none
                
            case let .toggleCompleted(book):
                var book2 = book
                book2.completed.toggle()

                environment.db.set(book.id!, to: book2, in: environment.books)
                return .none
                
            }
        }
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
