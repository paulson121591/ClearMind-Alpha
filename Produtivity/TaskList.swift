import Foundation
import UIKit

class TaskList: ObservableObject {
    @Published var tasks: [Task] = [] { // published property wrapper allows observing changes to the tasks array
        didSet {
            saveTasks() // save the updated tasks whenever the array changes
        }
    }
    
    private let taskKey = "tasks" // key for saving and loading tasks from UserDefaults
    
    init() {
        loadTasks() // load saved tasks from UserDefaults
        registerForNotifications() // register for notifications to save tasks when the app enters the background
    }
    
    private func saveTasks() {
        let encoder = JSONEncoder() // create a JSON encoder to encode the tasks array
        if let encoded = try? encoder.encode(tasks) { // encode the tasks array into a Data object
            UserDefaults.standard.set(encoded, forKey: taskKey) // save the encoded data to UserDefaults with the taskKey key
        }
    }
    
    private func loadTasks() {
        let decoder = JSONDecoder() // create a JSON decoder to decode the saved tasks
        if let tasksData = UserDefaults.standard.data(forKey: taskKey), // retrieve saved data from UserDefaults with the taskKey key
           let decodedTasks = try? decoder.decode([Task].self, from: tasksData) { // decode the data into an array of Task objects
            tasks = decodedTasks.map { task in // update the tasks array with the decoded tasks
                var loadedTask = task
                loadedTask.completed = task.completed // set the completed property to its saved value
                return loadedTask
            }
        }
    }
    
    private func registerForNotifications() {
        #if os(iOS) // compile this code only on iOS
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        ) // register for the notification that the app will resign active state (i.e., enter the background) and call the applicationWillResignActive function
        #else
        // For macOS and other platforms, we don't need to register for notifications
        #endif
    }
    
    @objc private func applicationWillResignActive() {
        saveTasks() // save the tasks array when the app enters the background
    }
    
    func updateTask(_ task: Task, completed: Bool? = nil) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) { // find the index of the task in the tasks array
            var updatedTask = task
            if let completed = completed {
                updatedTask.completed = completed // update the completed property of the task if specified
            }
            tasks[index] = updatedTask // replace the task at the index with the updated task
            saveTasks() // save the updated tasks array
        }
    }
    
    func deleteTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) { // find the index of the task in the tasks array
            tasks.remove(at: index) // remove the task at the index
            saveTasks() // save the updated tasks array
        }
    }
}

