//
//  Task.swift
//  Produtivity
//
//  Created by Paul Sfalanga on 2/22/23.
//
// Cal view
// task from message/email
// Inbox 
// priority is putting high on botton FIXED
// add sort by due date DONE
//
//Fix the complete button FIXED
//
//
//
//
//
//
//
import SwiftUI
import Foundation

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

struct Task: Codable, Identifiable {
    let id: UUID
    var title: String
    var priority: TaskPriority
    var completed: Bool {
        didSet {
            // Update the task's completion date when it is marked as completed
            if completed {
                completionDate = Date()
            } else {
                completionDate = nil
            }
        }
    }
    var notes: String?
    var dueDate: Date?
    var completionDate: Date?

    init(id: UUID = UUID(), title: String, priority: TaskPriority, completed: Bool = false, notes: String? = nil, dueDate: Date? = nil, completionDate: Date? = nil) {
        self.id = id
        self.title = title
        self.priority = priority
        self.completed = completed
        self.notes = notes
        self.dueDate = dueDate
        self.completionDate = completionDate
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, priority, completed, notes, dueDate, completionDate
    }

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

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(priority, forKey: .priority)
        try container.encode(completed, forKey: .completed)
        try container.encodeIfPresent(notes, forKey: .notes)
        try container.encodeIfPresent(dueDate, forKey: .dueDate)
        try container.encodeIfPresent(completionDate, forKey: .completionDate)
    }

    func formattedDueDate() -> String {
        guard let dueDate = dueDate else { return "No due date" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: dueDate)
    }
}
