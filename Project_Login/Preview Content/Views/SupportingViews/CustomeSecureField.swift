//
//  CustomeSecureField.swift
//  Project_Login
//
//  Created by MacBook One on 26/11/2024.
//

import SwiftUI

struct CustomSecureField: View {
    @Binding var password: String
    @Binding var isVisible: Bool
    var fieldHeight: CGFloat = 30
    var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.fill")
                .foregroundColor(.gray)
            
            Group {
                if isVisible {
                    TextField("Password", text: $password)
                } else {
                    SecureField("Password", text: $password)
                }
            }
            .textContentType(.password)
            .autocorrectionDisabled()
            
            Button(action: { isVisible.toggle() }) {
                Image(systemName: isVisible ? "eye.fill" : "eye.slash.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: isFocused ? .blue.opacity(0.3) : .gray.opacity(0.2),
                       radius: isFocused ? 6 : 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isFocused ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

#Preview {
    CustomSecureField(
        password: .constant(""), isVisible: .constant(false), isFocused: true
    )
}
