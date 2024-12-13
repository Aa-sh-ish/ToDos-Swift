//
//  CustomeInputField.swift
//  Project_Login
//
//  Created by MacBook One on 26/11/2024.
//

import SwiftUI

struct CustomInputField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var showClearButton: Bool = false
    var isFocused: Bool
    var fieldHeight: CGFloat = 30
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .textContentType(.none)
                .autocorrectionDisabled()
            
            if showClearButton && !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(height: fieldHeight)
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
    CustomInputField(
        icon: "person", placeholder: "Enter Email", text: .constant("") , isFocused: true
    )
}
