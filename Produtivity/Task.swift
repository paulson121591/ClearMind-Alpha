
import SwiftUI
import Foundation

// Define an enumeration of task priorities with associated colors
enum TaskPriority: String, CaseIterable, Codable {
    case low
    case medium
    case high

    var color: Color {
        switch self {
        case .low:
            return .green
        case .medium:
            return .orange
        case .high:
            return .red
        }
    }
}

// Define a struct representing a task with various properties
struct Task: Codable, Identifiable {
    let id: UUID // A unique identifier for the task
    var title: String // A title for the task
    var priority: TaskPriority // The priority level of the task
    var completed: Bool { // A boolean indicating whether the task has been completed
        didSet {
            // Update the task's completion date when it is marked as completed
            if completed {
                completionDate = Date()
            } else {
                completionDate = nil
            }
        }
    }
    var notes: String? // Optional notes for the task
    var dueDate: Date? // Optional due date for the task
    var completionDate: Date? // The date the task was completed (if applicable)

    // Initialize a new task with optional parameters, generating a unique ID if none is provided
    init(id: UUID = UUID(), title: String, priority: TaskPriority, completed: Bool = false, notes: String? = nil, dueDate: Date? = nil, completionDate: Date? = nil) {
        self.id = id
        self.title = title
        self.priority = priority
        self.completed = completed
        self.notes = notes
        self.dueDate = dueDate
        self.completionDate = completionDate
    }

    // Define the keys used for encoding and decoding the task
    private enum CodingKeys: String, CodingKey {
        case id, title, priority, completed, notes, dueDate, completionDate
    }

    // Initialize a task from a decoder, using the appropriate keys to extract values
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        priority = try container.decode(TaskPriority.self, forKey: .priority)
        completed = try container.decode(Bool.self, forKey: .completed)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
        dueDate = try container.decodeIfPresent(Date.self, forKey: .dueDate)
        completionDate = try container.decodeIfPresent(Date.self, forKey: .completionDate)
    }

    // Encode a task to a coder, using the appropriate keys to store values
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(priority, forKey: .priority)
        try container.encode(completed, forKey: .completed)
        try container.encodeIfPresent(notes, forKey: .notes)
        try container.encodeIfPresent(dueDate, forKey: .dueDate)
        try container.encodeIfPresent(completionDate, forKey: .completionDate)
        print("that encode")
    }
    func formattedDueDate() -> String {
        guard let dueDate = dueDate else { return "No due date" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: dueDate)
    }
}
