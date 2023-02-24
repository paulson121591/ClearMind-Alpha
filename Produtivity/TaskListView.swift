

import SwiftUI

struct TaskListView: View {
    @ObservedObject var taskList: TaskList
    @State private var sortOption: SortOption = .priority
    
    var body: some View {
        VStack {
            Picker("Sort by", selection: $sortOption) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Text(option.rawValue.capitalized)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            List {
                ForEach(sortedTasks()) { task in
                    NavigationLink(
                        destination: TaskDetailsView(viewModel: TaskDetailsViewModel(task: task, taskList: taskList))
                    ) {
                        TaskCell(task: task, taskList: taskList)
                    }
                    .foregroundColor(task.completed ? .gray : .primary)
                    .onAppear {
                        print("Task details view appeared for task: \(task.title)")
                    }
                    .onDisappear {
                        print("Task details view disappeared for task: \(task.title)")
                    }
                }
                .onDelete(perform: deleteTasks)
            }
        }
    }
    
    func deleteTasks(at offsets: IndexSet) {
        taskList.tasks.remove(atOffsets: offsets)
    }
    
    func sortedTasks() -> [Task] {
        switch sortOption {
        case .priority:
            return taskList.tasks.sorted(by: { $0.priority.rawValue > $1.priority.rawValue })
        }
    }
}








enum SortOption: String, CaseIterable {
    case priority = "Priority"
}
