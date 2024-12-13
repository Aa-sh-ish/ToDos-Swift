//
//  AuthViewModel.swift
//  Project_Login
//
//  Created by MacBook One on 25/11/2024.
//

import Foundation


enum AuthError {
    case invalidCredentials
    case invalidEmail
    case invalidPassword
    case dataSavefail
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid credentials. Please check your email and password."
        case .invalidEmail:
            return "The email address is not valid."
        case .invalidPassword:
            return "The password is not valid."
        case .dataSavefail:
            return "can't save data"
        }
    }
}

class AuthViewModel : ObservableObject {
    
    @Published var error: AuthError?
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    private func isValidEmail(_ email: String) -> Bool {
        // Regular expression for validating email with @ and .
        let emailRegex = "^[^@]+@[^@]+\\.[^@]+$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        // Regular expression for validating password (min 5 chars, at least one special char)
        let passwordRegex = "^(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{5,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    
    func login(userModel : UserLoginModel) -> Bool {
        if userModel.email.isEmpty || userModel.password.isEmpty  || userModel.name.isEmpty{
            error = .invalidCredentials
            return false
        }
        
        if(!isValidEmail(userModel.email)) {
            error = .invalidEmail
            return false
        }
        
        if(!isValidPassword(userModel.password)) {
            error = .invalidPassword
            return false
        }
        
        let isDataSaved = saveUserLoginData(model: userModel)
        if !isDataSaved {
            error = .dataSavefail
            return false
        }
        
        return true
    }
    
    private func saveUserLoginData(model: UserLoginModel)-> Bool {
          do {
              let encoder = JSONEncoder()
              let data = try encoder.encode(model)
              UserDefaults.standard.set(data, forKey: "loggedInUser")
              return true
          } catch {
              return false
          }
      }
    
    func getLoggedInUser() -> UserLoginModel? {
        if let data = UserDefaults.standard.data(forKey: "loggedInUser") {
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(UserLoginModel.self, from: data)
                return model
            } catch {
                print("Failed to decode user login data: \(error)")
            }
        }
        return nil
    }
    func deleteLoggedInUser() {
        UserDefaults.standard.removeObject(forKey: "loggedInUser")
    }
}
