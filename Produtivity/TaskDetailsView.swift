import SwiftUI

class TaskDetailsViewModel: ObservableObject {
    @Published var task: Task
    @Published var selectedPriority: TaskPriority
    
    var onSave: (() -> Void)?
    
    var taskList: TaskList // change access level to public
    
    init(task: Task, taskList: TaskList) {
        self.task = task
        self.selectedPriority = task.priority
        self.taskList = taskList
    }
    
    func saveTask() {
        task.priority = selectedPriority
        taskList.updateTask(task)
        onSave?()
        print("thats save det")
    }
}


struct TaskDetailsView: View {
    @ObservedObject var viewModel: TaskDetailsViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var showingDueDatePicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Task Notes")
                .font(.headline)
                .padding(.top)

            TextEditor(text: notesBinding)
                .frame(height: 200)
                .cornerRadius(8)
                .padding(.bottom)

            Text("Due Date")
                .font(.headline)

            DatePicker(
                "Due Date",
                selection: dueDateBinding,
                in: Date()...,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .padding(.bottom)

            Picker(selection: $viewModel.selectedPriority, label: Text("Priority")) {
                ForEach(TaskPriority.allCases, id: \.self) { priority in
                    Text("\(priority.rawValue)")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom)

            Spacer()

            Button("Save") {
                viewModel.saveTask()
                self.presentationMode.wrappedValue.dismiss()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(8)

        }
        .padding(16)
        .navigationBarTitle(viewModel.task.title)
        .navigationBarItems(trailing: Button("Cancel") {
            // do nothing, the user should use the back button to go back to the list
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
