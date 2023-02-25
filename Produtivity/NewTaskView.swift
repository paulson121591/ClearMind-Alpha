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
                Section(header: Text("Task Title")) {
                    TextField("Enter a title", text: $title)
                        .padding(.vertical, 8)
                }
                
                Section(header: Text("Task Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 200)
                        .cornerRadius(8)
                        .padding(.vertical, 8)
                }
                
                Section(header: Text("Priority")) {
                    Picker(selection: $priority, label: Text("")) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            Text(priority.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Due Date")) {
                    DatePicker(
                        selection: $dueDate,
                        in: Date()...,
                        displayedComponents: [.date, .hourAndMinute]
                    ) {
                        Text("Due Date")
                    }
                    .padding(.vertical, 8)
                }
                
                Section {
                    Button(action: {
                        let newTask = Task(
                            title: self.title,
                            priority: self.priority,
                            completed: false,
                            notes: self.notes,
                            dueDate: self.dueDate
                        )
                        taskList.tasks.append(newTask)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Add Task")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("New Task")
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
            })
        }
    }
}
