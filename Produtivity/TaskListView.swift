import SwiftUI

struct TaskListView: View {
    @ObservedObject var taskList: TaskList
    @State private var sortOption: SortOption = .priority
    
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
                    .mask(Text("ClearMind")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top)
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
            HStack {
                optionButton(for: .priority, image: "exclamationmark.triangle.fill")
                    .foregroundColor(sortOption == .priority ? .accentColor : .primary)
                
                Spacer()
                
                optionButton(for: .dueDate, image: "calendar")
                    .foregroundColor(sortOption == .dueDate ? .accentColor : .primary)
            }
            .padding(.horizontal)
            
            List {
                ForEach(sortedTasks()) { task in
                    NavigationLink(
                        destination: TaskDetailsView(viewModel: TaskDetailsViewModel(task: task, taskList: taskList))
                    ) {
                        TaskCell(task: task, taskList: taskList)
                            .foregroundColor(task.completed ? .secondary : .primary)
                    }
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
    
    @ViewBuilder func optionButton(for option: SortOption, image: String) -> some View {
        Button(action: {
            self.sortOption = option
        }) {
            Image(systemName: image)
                .font(.title)
                .frame(width: 40, height: 40)
        }
    }
    
    
    func deleteTasks(at offsets: IndexSet) {
        let sortedOffsets = offsets.sorted(by: >)
        let sortedTasks = self.sortedTasks()
        for index in sortedOffsets {
            let task = sortedTasks[index]
            if let taskIndex = taskList.tasks.firstIndex(where: { $0.id == task.id }) {
                taskList.tasks.remove(at: taskIndex)
            }
        }
    }

    func sortedTasks() -> [Task] {
        switch sortOption {
        case .priority:
            return taskList.tasks.sorted { task1, task2 in
                let completed1 = task1.completed
                let completed2 = task2.completed
                let priority1 = task1.priority
                let priority2 = task2.priority

                if completed1 == completed2 {
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
                } else {
                    return !completed1 && completed2
                }
            }
        case .dueDate:
            return taskList.tasks.sorted { task1, task2 in
                if task1.completed != task2.completed {
                    // If one task is completed and the other is not, move the completed task to the bottom of the list
                    return !task1.completed
                } else if let date1 = task1.dueDate, let date2 = task2.dueDate {
                    return date1 < date2
                } else {
                    // If neither task has a due date, sort by priority
                    return task1.priority.rawValue < task2.priority.rawValue
                }
            }
        }
    }
}

enum SortOption: String, CaseIterable {
    case priority = "Priority"
    case dueDate

}
