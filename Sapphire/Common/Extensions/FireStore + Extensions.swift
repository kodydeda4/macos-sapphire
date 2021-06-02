//
//  FireStore + Extensions.swift
//  Sapphire
//
//  Created by Kody Deda on 6/2/21.
//

import Firebase
import Combine

extension Firestore {
    enum DBError: Error, Equatable {
        case fetch
        case add
        case set
        case remove
    }

    func fetchData<A>(ofType: A.Type, from collection: String) -> AnyPublisher<Result<[A], DBError>, Never> where A: Codable {
        let rv = PassthroughSubject<Result<[A], DBError>, Never>()
        
        self.collection(collection).addSnapshotListener { querySnapshot, error in
            if let values = querySnapshot?
                .documents
                .compactMap({ try? $0.data(as: A.self) }) {
                
                rv.send(.success(values))
                
            } else {
                rv.send(.failure(.fetch))
            }
        }
        
        return rv.eraseToAnyPublisher()
    }
    
    func add<A>(_ value: A, to collection: String) -> AnyPublisher<Result<Bool, DBError>, Never> where A: Codable {
        let rv = PassthroughSubject<Result<Bool, DBError>, Never>()
        
        do {
            let _ = try self.collection(collection).addDocument(from: value)
            rv.send(.success(true))
        }
        catch {
            rv.send(.failure(.add))
        }
        
        return rv.eraseToAnyPublisher()
    }
    
    func remove(_ documentID: String, from collection: String) -> AnyPublisher<Result<Bool, DBError>, Never> {
        let rv = PassthroughSubject<Result<Bool, DBError>, Never>()
        
        self.collection(collection).document(documentID).delete { error in
            switch error {
            case .none:
                rv.send(.success(true))
            case .some:
                rv.send(.failure(.remove))
            }
        }
        
        return rv.eraseToAnyPublisher()
    }
    
    func set<A>(_ documentID: String, to value: A, in collection: String) -> AnyPublisher<Result<Bool, DBError>, Never> where A: Codable {
        let rv = PassthroughSubject<Result<Bool, DBError>, Never>()
        do {
            try self
                .collection(collection)
                .document(documentID)
                .setData(from: value)
            rv.send(.success(true))
        }
        catch {
            print(error)
            rv.send(.failure(.set))
        }
        return rv.eraseToAnyPublisher()
    }
}
