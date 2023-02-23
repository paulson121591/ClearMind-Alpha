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
            tasks = decodedTasks
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
    
    func updateTask(_ updatedTask: Task) {
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask
            saveTasks()
        }
    }
}
