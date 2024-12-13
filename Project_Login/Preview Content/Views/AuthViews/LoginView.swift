import SwiftUI

struct LoginView: View {
    // MARK: - Properties
    @StateObject var viewModel: AuthViewModel
    @State private var isPasswordVisible = false
    @State private var isLoggingIn = false
    @State private var isLoggedIn = false
    @State private var showingAlert = false
    @FocusState private var focusedField: Field?
    
    // MARK: - Constants
    private let cornerRadius: CGFloat = 16
    private let buttonHeight: CGFloat = 50
    
    private enum Field: Hashable {
        case username, email, password
    }
    
    // MARK: - View Components
    private var logoSection: some View {
        Image("App_Logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: screenWidth * 0.7, height: screenHeight * 0.2)
            .padding(.vertical, 20)
    }
    
    private var inputFields: some View {
        VStack(spacing: 16) {
            // Username Field
            CustomInputField(
                icon: "person.fill",
                placeholder: "Username",
                text: $viewModel.username,
                showClearButton: true,
                isFocused: focusedField == .username
            )
            .focused($focusedField, equals: .username)
            
            // Email Field
            CustomInputField(
                icon: "envelope.fill",
                placeholder: "Email",
                text: $viewModel.email,
                keyboardType: .emailAddress,
                showClearButton: true,
                isFocused: focusedField == .email
            )
            .focused($focusedField, equals: .email)
            .textContentType(.emailAddress)
            .autocapitalization(.none)
            
            // Password Field
            CustomSecureField(
                password: $viewModel.password,
                isVisible: $isPasswordVisible,
                isFocused: focusedField == .password
            )
            .focused($focusedField, equals: .password)
        }
    }
    
    private var loginButton: some View {
        Button(action: handleLogin) {
            HStack {
                if isLoggingIn {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text("Login")
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
        .disabled(isLoggingIn)
        .animation(.spring(), value: isLoggingIn)
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [.white, Color.blue.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        logoSection
                            .transition(.scale.combined(with: .opacity))
                        
                        inputFields
                            .transition(.move(edge: .trailing))
                        
                        loginButton
                            .padding(.top, 20)
                        
                        if let error = viewModel.error {
                            ErrorView(message: error.errorDescription ?? "Unknown error")
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
                .navigationDestination(isPresented: $isLoggedIn) {
                    BottomNavigationView(
                        userData: UserLoginModel(
                            name: viewModel.username,
                            email: viewModel.email,
                            password: viewModel.password,
                            deviceToken: ""
                        ),
                        viewModel: viewModel
                    )
                }
            }
        }
        .alert("Login Failed", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.error?.errorDescription ?? "Unknown error occurred")
        }
        .onChange(of: isLoggedIn) { newValue in
            if !newValue {
                resetForm()
            }
        }
    }
    
    // MARK: - Methods
    private func handleLogin() {
        hideKeyboard()
        isLoggingIn = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let userModel = UserLoginModel(
                name: viewModel.username,
                email: viewModel.email,
                password: viewModel.password,
                deviceToken: ""
            )
            
            let success = viewModel.login(userModel: userModel)
            isLoggingIn = false
            
            if success {
                withAnimation {
                    isLoggedIn = true
                }
            } else {
                showingAlert = true
            }
        }
    }
    
    private func resetForm() {
        viewModel.username = ""
        viewModel.email = ""
        viewModel.password = ""
        viewModel.error = nil
        isPasswordVisible = false
        focusedField = nil
    }
}

// MARK: - Supporting Views


struct ErrorView: View {
    let message: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text(message)
                .foregroundColor(.red)
                .font(.subheadline)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Helper Extensions
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                      to: nil, from: nil, for: nil)
    }
}

// MARK: - Preview
#Preview {
    LoginView(viewModel: AuthViewModel())
}
