//
//  ButtomNavigationView.swift
//  Project_Login
//
//  Created by MacBook One on 26/11/2024.
//

import SwiftUI
import SwiftData

struct BottomNavigationView: View {
    var userData: UserLoginModel
    var viewModel: AuthViewModel
    
    private let container: ModelContainer
    private let taskViewModel: TaskViewModel

    init(userData: UserLoginModel, viewModel: AuthViewModel) {
        self.userData = userData
        self.viewModel = viewModel
        
        do {
            // Initialize the container and TaskViewModel in the initializer
            self.container = try ModelContainer(for: TaskModel.self)
            self.taskViewModel = TaskViewModel(context: container.mainContext)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    var body: some View {
        TabView {
            HomeView(taskViewModel: taskViewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            
            ToDosView(taskViewModel: taskViewModel)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("ToDos")
                }

            SettingView(
                userData: userData,
                viewModel: viewModel
            )
            .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
}


#Preview {
    BottomNavigationView(
        userData: UserLoginModel(
            name: "SwiftUI",
            email: "swiftui@gmail.com",
            password: "123456",
            deviceToken: "1234567890"
        ),
        viewModel: AuthViewModel()
    )
}
