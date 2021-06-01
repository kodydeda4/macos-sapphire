////
////  Task.swift
////  Sapphire
////
////  Created by Kody Deda on 6/1/21.
////
//
//import Foundation
//import Combine
//
//import Firebase
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//
//// https://peterfriese.dev/swiftui-firebase-fetch-data/
//// https://peterfriese.dev/swiftui-firebase-codable/
//
////MARK:- Model
//
//struct Task: Codable, Identifiable {
//    @DocumentID var id = UUID().uuidString
//    var title: String
//    var upgraded = false
//}
//
//let testDataTasks = [
//    Task(title: "ImplementUI", upgraded: true),
//    Task(title: "Connect to Firebase", upgraded: false),
//    Task(title: "???", upgraded: false),
//    Task(title: "Profit", upgraded: false)
//]
//
//
////MARK:- ViewModel
//
//class TaskCellViewModel: ObservableObject, Identifiable {
//    @Published var task: Task
//    
//    var id = ""
//    @Published var completionStateIconName = ""
//    
//    private var cancellables = Set<AnyCancellable>()
//    init(task: Task) {
//        self.task = task
//        
//        $task
//            .map { $0.upgraded ? "checkmark.circle.fill" : "circle" }
//            .assign(to: \.completionStateIconName, on: self)
//            .store(in: &cancellables)
//        
//        
//        $task
//            .map { $0.id! }
//            .assign(to: \.id, on: self)
//            .store(in: &cancellables)
//    }
//}
//
//class TaskListViewModel: ObservableObject {
//    @Published var taskRepository = TaskRepository()
//    @Published var taskCellViewModels = [TaskCellViewModel]()
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    init() {
//        //self.taskCellViewModels = testDataTasks.map(TaskCellViewModel.init)
//        taskRepository.$tasks
//            .map { $0.map(TaskCellViewModel.init) }
//            .assign(to: \.taskCellViewModels, on: self)
//            .store(in: &cancellables)
//    }
//    
//    func addTask(task: Task) {
//        taskRepository.addTask(task: task)
////        let taskVM = TaskCellViewModel(task: task)
////        self.taskCellViewModels.append(taskVM)
//    }
//}
//
////MARK:- Repositories
//
//class TaskRepository: ObservableObject {
//    let db = Firestore.firestore()
//    
//    @Published var tasks = [Task]()
//    
//    init() {
//        loadData()
//    }
//    
//    
//    func loadData() {
//        db.collection("UserData").addSnapshotListener { (querySnapshot, error) in
//          guard let documents = querySnapshot?.documents else {
//            print("No documents")
//            return
//          }
//            
//          self.tasks = documents.compactMap { queryDocumentSnapshot -> Task? in
//            return try? queryDocumentSnapshot.data(as: Task.self)
//          }
//        }
//    }
//    
//    func addTask(task: Task) {
//      do {
//        let _ = try db.collection("UserData").addDocument(from: task)
//      }
//      catch {
//        print(error)
//      }
//    }
//
//}
