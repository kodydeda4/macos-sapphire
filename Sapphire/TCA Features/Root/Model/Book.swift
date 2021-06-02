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
    }
    
    enum Action: Equatable {
        case fetchData
        case fetchDataResult(Result<[Book], AppError>)
        case addBook
        case removeBook(Book)
        case toggleCompleted(Book)
//        case clearCompleted
//        case clearCompletedResult(Result<[Book], AppError>)
        case changeTitle(Result<[Book], AppError>)
    }
    
    struct Environment {
        private var db = Firestore.firestore()
        
        enum DBCollection: String {
            case books = "books"
        }
        
        func fetchData() -> Effect<Action, Never> {
            let rv = PassthroughSubject<Result<[Book], AppError>, Never>()
            
            db.collection("books").addSnapshotListener { querySnapshot, error in
                if let books = querySnapshot?
                    .documents
                    .compactMap({ try? $0.data(as: Book.self) }) {
                    
                    rv.send(.success(books))
                    
                } else {
                    rv.send(.failure(AppError(error!)))
                }
            }
            
            return rv
                .eraseToAnyPublisher()
                .map(Action.fetchDataResult)
                .receive(on: DispatchQueue.main)
                .eraseToEffect()
        }
        
        func add<A>(_ value: A, to collection: DBCollection) where A: Codable {
            do {
                let _ = try db.collection(collection.rawValue).addDocument(from: value)
            }
            catch {
                print(error)
            }
        }
                
        func remove(_ documentId: String, from collection: DBCollection) {
            db.collection(collection.rawValue).document(documentId).delete { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        
        func toggleCompleted(book: Book) {
            var book2 = book
            book2.completed.toggle()
            
            if let id = book.id {
                do {
                    try db
                        .collection("books")
                        .document(id)
                        .setData(from: book2)
                }
                
                catch {
                    print(error)
                }
            }
        }
        
//        func clearCompleted() -> Effect<Action, Never> {
//            let rv = PassthroughSubject<Result<[Book], AppError>, Never>()
//
//            db.collection("books").addSnapshotListener { (querySnapshot, error) in
//                guard let documents = querySnapshot?.documents
//                else {
//                    rv.send(.failure(AppError(error!)))
//                    return
//                }
//
//                documents
//                    .compactMap { try? $0.data(as: Book.self) }
//                    .filter(\.completed)
//                    //.forEach(removeBook)
//            }
//
//            return rv
//                .eraseToAnyPublisher()
//                .map(Action.clearCompletedResult)
//                .receive(on: DispatchQueue.main)
//                .eraseToEffect()
//
//        }
    }
}

extension BooksList {
    static let reducer = Reducer<State, Action, Environment>.combine(
        // pullbacks
        Reducer { state, action, environment in
            switch action {
            
            case .fetchData:
                return environment.fetchData()
                
            case let .fetchDataResult(.success(books)):
                state.books = books
                return .none
                
            case let .fetchDataResult(.failure(error)):
                print(error.localizedDescription)
                return .none
                
            case .addBook:
                let book = Book.init(title: "Title", author: "Author", numberOfPages: 256)

                environment.add(book, to: .books)
                return .none
                
            case let .removeBook(book):
                environment.remove(book.id!, from: .books)
                return .none
                
            case let .toggleCompleted(book):
                environment.toggleCompleted(book: book)
                return .none
                
//            case .clearCompleted:
//                return environment.clearCompleted()
//
//            case let .clearCompletedResult(.success(books)):
//                state.books = books
//                return .none
//
//            case let .clearCompletedResult(.failure(error)):
//                return .none
                
            case let .changeTitle(value):
                
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
                viewStore.send(.fetchData)
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
