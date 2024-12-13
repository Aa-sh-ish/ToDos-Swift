import SwiftUI

struct SettingView: View {
    // MARK: - Properties
    let userData: UserLoginModel
    @ObservedObject var viewModel: AuthViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    // State properties for UI interactions
    @State private var showLogoutAlert = false
    @State private var profileMenuVisible = false
    
    // MARK: - View Components
    private var welcomeSection: some View {
        VStack(spacing: 12) {
            UserAvatar(name: userData.name)
                .frame(width: 100, height: 100)
            
            Text("Welcome back,")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text(userData.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 32)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: { showLogoutAlert = true }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Logout")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 2)
            }
            
            Button(action: { profileMenuVisible.toggle() }) {
                HStack {
                    Image(systemName: "person.circle")
                    Text("Profile Settings")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 2)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                welcomeSection
                
                Divider()
                    .padding(.horizontal)
                
//                userInfoSection
                
                Divider()
                    .padding(.horizontal)
                
                actionButtons
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Settings") { /* Add settings action */ }
                    Button("Help") { /* Add help action */ }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .alert("Logout", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                handleLogout()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
        .sheet(isPresented: $profileMenuVisible) {
            ProfileSettingsView(userData: userData)
        }
    }
    
    // MARK: - Helper Methods
    private func handleLogout() {
        withAnimation {
            viewModel.deleteLoggedInUser()
            dismiss()
        }
    }
}

// MARK: - Supporting Views
struct UserAvatar: View {
    let name: String
    
    var body: some View {
        Circle()
            .fill(Color.blue.opacity(0.2))
            .overlay(
                Text(name.prefix(1).uppercased())
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.blue)
            )
    }
}

struct InfoCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.body)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct ProfileSettingsView: View {
    let userData: UserLoginModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Personal Information") {
                    Text("Name: \(userData.name)")
                    Text("Email: \(userData.email)")
                }
                
                Section("Security") {
                    Button("Change Password") {
                        // Add password change functionality
                    }
                    
                    Button("Two-Factor Authentication") {
                        // Add 2FA setup
                    }
                }
                
                Section("Preferences") {
                    Toggle("Push Notifications", isOn: .constant(true))
                    Toggle("Email Updates", isOn: .constant(false))
                }
            }
            .navigationTitle("Profile Settings")
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        SettingView(
            userData: .init(
                name: "SwiftUI",
                email: "swiftui@gmail.com",
                password: "123456",
                deviceToken: "1234567890"
            ),
            viewModel: .init()
        )
    }
}
