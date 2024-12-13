//
//  ContentView.swift
//  Project_Login
//
//  Created by MacBook One on 25/11/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = AuthViewModel()
    
    var body: some View {
     if   let loggedinUser = viewModel.getLoggedInUser(){
         BottomNavigationView(
            userData: loggedinUser,
            viewModel: viewModel
         )
     }else{
         LoginView(
            viewModel: viewModel
         )
     }
    }
}

#Preview {
    ContentView()
}
