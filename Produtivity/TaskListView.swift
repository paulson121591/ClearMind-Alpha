import SwiftUI

struct TaskListView: View {
    @ObservedObject var taskList: TaskList
    @State private var sortOption: SortOption = .priority
    
    var body: some View {
        VStack {
            Menu {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button(action: {
                        self.sortOption = option
                    }) {
                        Text(option.rawValue.capitalized)
                    }
                }
            } label: {
                Label("Sort by: \(sortOption.rawValue.capitalized)", systemImage: "arrow.up.arrow.down.circle.fill")
            }
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
            return taskList.tasks.sorted { task1, task2 in
                let priority1 = task1.priority
                let priority2 = task2.priority
                
                if priority1 == .high {
                    return true
                } else if priority2 == .high {
                    return false
                } else if priority1 == .medium {
                    return true
                } else if priority2 == .medium {
                    return false
                } else {
                    return true
                }
            }
        case .dueDate:
            return taskList.tasks.sorted { task1, task2 in
                guard let date1 = task1.dueDate, let date2 = task2.dueDate else {
                    // If either task has no due date, sort it to the end of the list
                    return task2.dueDate != nil
                }
                return date1 < date2
            }
        }
    }
}

enum SortOption: String, CaseIterable {
    case priority = "Priority"
    case dueDate = "Due Date"
}
