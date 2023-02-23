//
//  NewTaskView.swift
//  Produtivity
//
//  Created by Paul Sfalanga on 2/22/23.
//

import SwiftUI

struct NewTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var taskList: TaskList
    
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var priority: TaskPriority = .medium
    @State private var dueDate: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Task title", text: $title)
                }
                Section(header: Text("Task Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 200)
                        .cornerRadius(8)
                }
                Section(header: Text("Priority")) {
                    Picker(selection: $priority, label: Text("Priority")) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            Text("\(priority.rawValue)")
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section(header: Text("Due Date")) {
                    DatePicker(selection: $dueDate, in: Date()..., displayedComponents: [.date, .hourAndMinute]) {
                        Text("Due Date")
                    }
                }
                Section {
                    Button("Add Task") {
                        let newTask = Task(title: self.title, priority: self.priority, completed: false, notes: self.notes, dueDate: self.dueDate)
                        taskList.tasks.append(newTask)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("New Task")
        }
    }
}
