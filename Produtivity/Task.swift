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

    enum CodingKeys: String, CodingKey {
        case rawValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        guard let priority = TaskPriority(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(forKey: .rawValue, in: container, debugDescription: "Invalid priority value")
        }
        self = priority
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rawValue, forKey: .rawValue)
    }
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        priority = try container.decode(TaskPriority.self, forKey: .priority)
        completed = try container.decode(Bool.self, forKey: .completed)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(priority, forKey: .priority)
        try container.encode(completed, forKey: .completed)
        try container.encodeIfPresent(notes, forKey: .notes)
    }
}

