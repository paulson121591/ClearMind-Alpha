import Foundation
import UIKit

class TaskList: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet {
            saveTasks()
        }
    }
    
    private let taskKey = "tasks"
    
    init() {
        loadTasks()
        registerForNotifications()
    }
    
    private func saveTasks() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: taskKey)
        }
    }
    
    private func loadTasks() {
        let decoder = JSONDecoder()
        if let tasksData = UserDefaults.standard.data(forKey: taskKey),
           let decodedTasks = try? decoder.decode([Task].self, from: tasksData) {
            tasks = decodedTasks.map { task in
                var loadedTask = task
                loadedTask.completed = task.completed // set completed property to its saved value
                return loadedTask
            }
        }
    }
    
    private func registerForNotifications() {
        #if os(iOS)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        #else
        // For macOS and other platforms, we don't need to register for notifications
        #endif
    }
    
    @objc private func applicationWillResignActive() {
        saveTasks()
    }
    
    func updateTask(_ task: Task, completed: Bool? = nil) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            var updatedTask = task
            if let completed = completed {
                updatedTask.completed = completed
            }
            tasks[index] = updatedTask
            saveTasks()
        }
    }
    
    func deleteTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
            saveTasks()
        }
    }
}

