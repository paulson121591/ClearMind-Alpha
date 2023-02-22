import SwiftUI

struct TaskListView: View {
    @ObservedObject var taskList: TaskList
    
    var body: some View {
        List {
            ForEach(taskList.tasks) { task in
                NavigationLink(
                    destination: TaskDetailsView(viewModel: TaskDetailsViewModel(task: task))
                ) {
                    HStack {
                        Image(systemName: task.completed ? "checkmark.square" : "square")
                            .onTapGesture {
                                // You cannot modify a constant `task`, so you need to get the index of the task and update it via the taskList instead
                                if let index = taskList.tasks.firstIndex(where: { $0.id == task.id }) {
                                    taskList.tasks[index].completed.toggle()
                                }
                            }
                        Text(task.title)
                    }
                }
                .foregroundColor(task.completed ? .gray : .primary)
            }
            .onDelete(perform: deleteTasks)
        }
    }
    
    func deleteTasks(at offsets: IndexSet) {
        taskList.tasks.remove(atOffsets: offsets)
    }
}

