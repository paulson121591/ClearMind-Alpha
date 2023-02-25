//
//  ContentView.swift
//  Produtivity
//
//  Created by Paul Sfalanga on 2/22/23.
//

import SwiftUI

struct ContentView: View {
    // Observe changes to the taskList object
    @ObservedObject var taskList = TaskList()
    
    // Show/hide the "add task" sheet
    @State private var showingAddTask = false
    
    var body: some View {
        // Set up a navigation view
        NavigationView {
            // Display the task list
            TaskListView(taskList: taskList)
                // Add a toolbar with an Edit button on the left and an Add button on the right
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.showingAddTask = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                // Show the "add task" sheet when the Add button is tapped
                .sheet(isPresented: $showingAddTask) {
                    NewTaskView(taskList: taskList)
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
