//
//  UserModel.swift
//  Project_Login
//
//  Created by MacBook One on 25/11/2024.
//

struct UserRegisterModel  :Codable{
    let name: String
    let email: String
    let password: String
}



struct UserLoginModel : Codable {
    let name : String
    let email: String
    let password: String
    let deviceToken: String
}
