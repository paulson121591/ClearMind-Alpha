import SwiftUI

class TaskDetailsViewModel: ObservableObject {
    @Published var task: Task
    var onSave: (() -> Void)?

    init(task: Task) {
        self.task = task
    }

    func saveTask() {
        // Save the changes made to the task here
        onSave?()
    }
}

struct TaskDetailsView: View {
    @ObservedObject var viewModel: TaskDetailsViewModel

    var body: some View {
        Form {
            Section(header: Text("Task Notes")) {
                TextEditor(text: notesBinding)
            }
        }
        .navigationTitle(viewModel.task.title)
        .navigationBarItems(trailing: Button("Save", action: {
            viewModel.saveTask()
        }))
    }

    var notesBinding: Binding<String> {
        Binding(
            get: { viewModel.task.notes ?? "" },
            set: { viewModel.task.notes = $0 }
        )
    }
}
