//
//  HomeView.swift
//  Project_Login
//
//  Created by MacBook One on 26/11/2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject var taskViewModel: TaskViewModel
    
    @FocusState private var focusedField: Field?
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var isTaskSaved: Bool = false
    @State private var date = Date()
    
    private let cornerRadius: CGFloat = 16
    private let buttonHeight: CGFloat = 50
    
    private enum Field: Hashable {
        case title, description
    }
    
    private var SaveButton: some View {
        Button(action: saveData) {
            HStack {
                if isTaskSaved {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text("Save")
                        .font(.headline)
                }
            }
            .frame(maxWidth: screenWidth * 0.45, minHeight: buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.blue)
            )
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 2)
        }
        .disabled(isTaskSaved || title.isEmpty)
        .animation(.spring(), value: isTaskSaved)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack {
                Text("Add a task")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)
                    .frame(width: screenWidth, height: 50)
            }
            .background(.tertiary)
            
            CustomInputField(
                icon: "list.dash.header.rectangle",
                placeholder: "Title",
                text: $title,
                keyboardType: .default,
                showClearButton: true,
                isFocused: focusedField == .title
            )
            .focused($focusedField, equals: .title)
            .textContentType(.none)
            .autocapitalization(.sentences)
            
            CustomInputField(
                icon: "text.document.fill",
                placeholder: "Description",
                text: $description,
                keyboardType: .default,
                showClearButton: true,
                isFocused: focusedField == .description,
                fieldHeight: 200
            )
            .focused($focusedField, equals: .description)
            .textContentType(.none)
            .autocapitalization(.sentences)
            
            DatePicker(
                "Deadline",
                selection: $date,
                displayedComponents: [.date]
            )
            
            SaveButton
                .padding(.top, 20)
            
                    Spacer()
        }
        .padding()
        

    }
    
    private func saveData() {
        hideKeyboard()
        
        guard !title.isEmpty else { return }
        
        isTaskSaved = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            taskViewModel.saveTask(
                title: title,
                description: description,
                dueDate: date,
                isCompleted: false
            )
            
            isTaskSaved = false
            clearFields()
        }
    }
    
    private func clearFields() {
        title = ""
        description = ""
        date = Date()
        focusedField = nil
    }
}

#Preview {
    let container = try! ModelContainer(for: TaskModel.self)
    HomeView(taskViewModel: TaskViewModel(context: container.mainContext))
}
