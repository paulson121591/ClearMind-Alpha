import SwiftUI

struct TaskListView: View {
    @ObservedObject var taskList: TaskList
    @State private var sortOption: SortOption = .priority
    
    var body: some View {
        VStack {
            Picker("Sort by", selection: $sortOption) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Text(option.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            List {
                ForEach(sortedTasks()) { task in
                    NavigationLink(
                        destination: TaskDetailsView(viewModel: TaskDetailsViewModel(task: task, taskList: taskList))
                    ) {
                        HStack {
                            Image(systemName: task.completed ? "checkmark.square" : "square")
                                .onTapGesture {
                                    if let index = taskList.tasks.firstIndex(where: { $0.id == task.id }) {
                                        taskList.tasks[index].completed.toggle()
                                    }
                                }
                            Text(task.title)
                                .foregroundColor(task.completed ? .gray : task.priority.color) // assign text color based on priority
                        }
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

extension TaskPriority {
    var color: Color {
        switch self {
        case .low:
            return .green
        case .medium:
            return .orange
        case .high:
            return .red
        }
    }
}

enum SortOption: String, CaseIterable {
    case priority = "Priority"
}
