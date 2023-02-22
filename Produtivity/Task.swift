//
//  Task.swift
//  Produtivity
//
//  Created by Paul Sfalanga on 2/22/23.
//

import Foundation

enum TaskPriority: Int, CaseIterable, Codable {
    case low = 1
    case medium = 2
    case high = 3
}

struct Task: Codable, Identifiable {
    let id: UUID
    var title: String
    var priority: TaskPriority
    var completed: Bool
    var notes: String?

    init(id: UUID = UUID(), title: String, priority: TaskPriority, completed: Bool = false, notes: String? = nil) {
        self.id = id
        self.title = title
        self.priority = priority
        self.completed = completed
        self.notes = notes
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, priority, completed, notes
    }
}

