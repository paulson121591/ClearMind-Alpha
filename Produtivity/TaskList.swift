//
//  TaskList.swift
//  Produtivity
//
//  Created by Paul Sfalanga on 2/22/23.
//

import Foundation

class TaskList: ObservableObject {
    @Published var tasks: [Task] = []
}
