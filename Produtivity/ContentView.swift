//
//  ContentView.swift
//  Produtivity
//
//  Created by Paul Sfalanga on 2/22/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var taskList = TaskList()
    @State private var showingAddTask = false
    
    var body: some View {
        NavigationView {
            TaskListView(taskList: taskList)
                .navigationBarTitle("Tasks")
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
