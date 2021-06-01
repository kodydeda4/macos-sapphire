//
//  Book.swift
//  Sapphire
//
//  Created by Kody Deda on 6/1/21.
//

import Foundation
import FirebaseFirestoreSwift


//SwiftUI: Fetching Data from Firestore in Real Time (April 2020)
//https://peterfriese.dev/swiftui-firebase-fetch-data/


//SwiftUI: Mapping Firestore Documents using Swift Codable (May 2020)
//https://peterfriese.dev/swiftui-firebase-codable/

//Mapping Firestore Data in Swift
//https://peterfriese.dev/firestore-codable-the-comprehensive-guide/



// MARK:- Model
struct Book: Identifiable, Codable {
    @DocumentID var id: String?
    @ServerTimestamp var createdAt: Date?
    var title: String
    var author: String
    var numberOfPages: Int
    var completed: Bool = false
}

// MARK:- ViewModel

import Foundation
import FirebaseFirestore

class BooksViewModel: ObservableObject {
    @Published var books = [Book]()
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("books").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.books = documents.compactMap { queryDocumentSnapshot -> Book? in
                return try? queryDocumentSnapshot.data(as: Book.self)
            }
        }
    }
    
    func addBook(book: Book) {
        do {
            let _ = try db.collection("books").addDocument(from: book)
        }
        catch {
            print(error)
        }
    }
    
    
    func toggleCompleted(book: Book) {
        if let id = book.id {
            let docRef = db.collection("books").document(id)
            do {
                
                var book2 = book
                book2.completed.toggle()
                
                try docRef.setData(from: book2)
            }
            catch {
                print(error)
            }
        }
    }
    
    private func removeBook(book: Book) {
        if let documentId = book.id {
            db.collection("books").document(documentId).delete { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func clearCompleted() {
        books.filter(\.completed).forEach(removeBook)
    }
}

// MARK:- View

import SwiftUI

struct BooksListView: View {
    @ObservedObject var viewModel = BooksViewModel()
    
    var body: some View {
        
        List(viewModel.books) { book in
            Button(action: { viewModel.toggleCompleted(book: book) }) {
                HStack {
                    Image(systemName: book.completed ? "largecircle.fill.circle" : "circle")
                    
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
                .background(GroupBox { Color.clear }.opacity(0.0001))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .onAppear() {
            viewModel.fetchData()
        }
        .toolbar {
            ToolbarItem {
                Button("add") {
                    viewModel.addBook(
                        book: Book.init(
                            title: "Title",
                            author: "Author",
                            numberOfPages: 12309
                        )
                    )
                }
            }
            ToolbarItem {
                Button("Clear Completed") {
                    viewModel.clearCompleted()
                }
            }
        }
    }
}

