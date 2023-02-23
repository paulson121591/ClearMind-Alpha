import SwiftUI

class TaskDetailsViewModel: ObservableObject {
    @Published var task: Task
    @Published var selectedPriority: TaskPriority
    
    var onSave: (() -> Void)?
    
    private var taskList: TaskList
    
    init(task: Task, taskList: TaskList) {
        self.task = task
        self.selectedPriority = task.priority
        self.taskList = taskList
    }
    
    func saveTask() {
        task.priority = selectedPriority
        taskList.updateTask(task)
        onSave?()
    }
}

struct TaskDetailsView: View {
    @ObservedObject var viewModel: TaskDetailsViewModel

    @State private var showingDueDatePicker = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Task Notes")
                .font(.headline)
                .padding(.top)

            TextEditor(text: notesBinding)
                .frame(height: 200)
                .cornerRadius(8)
                .padding(.bottom)

            Text("Due Date")
                .font(.headline)

            Button(action: {
                showingDueDatePicker = true
            }, label: {
                Text(viewModel.task.dueDate == nil ? "Add due date" : DateFormatter.localizedString(from: viewModel.task.dueDate!, dateStyle: .medium, timeStyle: .short))
            })
            .padding(.bottom)
            .sheet(isPresented: $showingDueDatePicker) {
                DatePicker(
                    "Due Date",
                    selection: dueDateBinding,
                    in: Date()...,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .frame(height: 250)
                .navigationBarItems(trailing: Button("Done") {
                    showingDueDatePicker = false
                })
            }

            Text("Priority")
                .font(.headline)

            Picker(selection: $viewModel.selectedPriority, label: Text("Priority")) {
                ForEach(TaskPriority.allCases, id: \.self) { priority in
                    Text("\(priority.rawValue)")
                }
            }
            .pickerStyle(.segmented)
            .padding(.bottom)
        }
        .padding()
        .navigationBarTitle(viewModel.task.title)
        .navigationBarItems(trailing: Button("Save") {
            viewModel.saveTask()
        })
    }

    var notesBinding: Binding<String> {
        Binding(
            get: { viewModel.task.notes ?? "" },
            set: { viewModel.task.notes = $0 }
        )
    }

    var dueDateBinding: Binding<Date> {
        Binding(
            get: { viewModel.task.dueDate ?? Date() },
            set: { viewModel.task.dueDate = $0 }
        )
    }

}
