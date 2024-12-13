//
//  TaskViewModel.swift
//  Project_Login
//
//  Created by MacBook One on 26/11/2024.
//
import Foundation
import SwiftData

import Foundation
import SwiftData

@MainActor
class TaskViewModel: ObservableObject {
    private let context: ModelContext
    
    @Published private(set) var tasks: [TaskModel] = []
    
    init(context: ModelContext) {
        self.context = context
        fetchTasks()
    }
    
    func fetchTasks() {
        do {
            tasks = try context.fetch(FetchDescriptor<TaskModel>())
        } catch {
            print("Error fetching tasks: \(error)")
        }
    }
    
    func saveTask(title: String, description: String, dueDate: Date, isCompleted: Bool) -> Bool {
        guard !title.isEmpty else { return false }
        
        let newTask = TaskModel(title: title, description: description, dueDate: dueDate, isCompleted: isCompleted)
        context.insert(newTask)
        
        return saveContext()
    }
    
    func updateTask(
        task: TaskModel,
        newTitle: String,
        newDescription: String,
        newDueDate: Date,
        newIsCompleted: Bool
    ) {
        task.title = newTitle
        task.taskDescription = newDescription
        task.dueDate = newDueDate
        task.isCompleted = newIsCompleted
        
        _ = saveContext()
    }
    
    func deleteTask(task: TaskModel) {
        context.delete(task)
        _ = saveContext()
    }
    
    @discardableResult
    private func saveContext() -> Bool {
        do {
            try context.save()
            fetchTasks()
            return true
        } catch {
            print("Error saving context: \(error)")
            return false
        }
    }
}
