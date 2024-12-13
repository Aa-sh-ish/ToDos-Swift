//
//  TaskModel.swift
//  Project_Login
//
//  Created by MacBook One on 26/11/2024.
//

import Foundation
import SwiftData

@Model
class TaskModel: Identifiable {
    @Attribute(.unique) var id: String
    var title: String
    var taskDescription: String
    var dueDate: Date
    var isCompleted: Bool
    
    init(title: String, description: String, dueDate: Date, isCompleted: Bool) {
        self.id = UUID().uuidString
        self.title = title
        self.taskDescription = description
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }
}
