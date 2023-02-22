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
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Task title", text: $title)
                }
                Button("Add Task") {
                    let newTask = Task(title: self.title, priority: .medium, completed: false, notes: "")
                    taskList.tasks.append(newTask)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("New Task")
        }
    }
}
