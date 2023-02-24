import SwiftUI



struct TaskCell: View {
    let task: Task
    let taskList: TaskList
    @State private var isCompleted: Bool

    init(task: Task, taskList: TaskList) {
        self.task = task
        self.taskList = taskList
        _isCompleted = State(initialValue: task.completed)
    }

    var body: some View {
        HStack {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .onTapGesture {
                    withAnimation {
                        isCompleted.toggle()
                        taskList.updateTask(task)
                    }
                }


            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)

                HStack {
                    Text(task.priority.rawValue.capitalized)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(task.priority.color)
                        .cornerRadius(8)

                    if let dueDate = task.dueDate {
                        Text("Due \(task.formattedDueDate())")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

