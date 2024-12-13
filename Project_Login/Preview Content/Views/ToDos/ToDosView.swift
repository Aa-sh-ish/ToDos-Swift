//
//  ToDosView.swift
//  Project_Login
//
//  Created by MacBook One on 26/11/2024.
//

import SwiftUI
import SwiftData

struct ToDosView: View {
    @StateObject var taskViewModel: TaskViewModel

    var body: some View {
        VStack {
            Text("Task List")
                .font(.title)
                .padding()

            // Display tasks using a List
            List(taskViewModel.tasks) { task in
                VStack(alignment: .leading) {
                    Text(task.title)
                        .font(.headline)
                    Text(task.taskDescription)
                        .font(.subheadline)
                    Text("Due: \(task.dueDate, formatter: dateFormatter)")
                        .font(.caption)
                }
            }
        }
        .onAppear {
            taskViewModel.fetchTasks()
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
}

#Preview {
    let container = try! ModelContainer(for: TaskModel.self)
    ToDosView(taskViewModel: TaskViewModel(context: container.mainContext))
}
