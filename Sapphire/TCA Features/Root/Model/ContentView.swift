////
////  ContentView.swift
////  Sapphire
////
////  Created by Kody Deda on 6/1/21.
////
//
//import SwiftUI
//
//struct TaskListView: View {
//    @ObservedObject var taskListVM = TaskListViewModel()
//    @State var presentAddItem = false
//    
//    var body: some View {
//        List {
//            ForEach(taskListVM.taskCellViewModels) { task in
//                TaskCellView(task: task, onCommit: {})
//            }
//            
//            if presentAddItem {
//                TaskCellView.init(task: TaskCellViewModel(task: Task.init(title: "Foo")), onCommit: {})
//            }
//        }
//        .toolbar {
//            ToolbarItem {
//                Button("Add Todo") {
//                    self.presentAddItem.toggle()
//                }
//            }
//        }
//    }
//}
//
//struct TaskCellView: View {
//    var task: TaskCellViewModel
//    var onCommit: () -> Void
//    
//    var body: some View {
//        HStack {
//            Button(action: { onCommit() }) {
//                Image(systemName: task.completionStateIconName)
//            }
//        }
//    }
//}
//
//
//// MARK:- SwiftUI_Previews
//struct TaskListView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskListView()
//    }
//}
//
