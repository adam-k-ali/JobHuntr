//
//  SignUpView.swift
//  JobHuntr
//
//  Created by Adam Ali on 14/02/2023.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var username = ""
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var error = ""
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Section {
                TextField("Username", text: $username)
                TextField("E-Mail", text: $email)
                SecureField("Password", text: $password)
                SecureField("Confirm Password", text: $confirmPassword)
                Text(error)
                    .font(.headline)
                    .foregroundColor(.red)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Sign Up", action: {
                if password != confirmPassword {
                    error = "Passwords don't match"
                    return
                }
                isLoading = true
                Task {
                    await sessionManager.signUp(username: username, email: email, password: password, errorMsg: $error)
                }
                isLoading = false
            })
            if isLoading {
                ProgressView()
            }
            Spacer()
            VStack(spacing: 16) {
                Button("Already have an account? Sign In.", action: {
                    sessionManager.showLogin()
                })
                Button("Looking to confirm your account? Click here.", action: {
                    if username.isEmpty {
                        error = "To confirm, enter username."
                    } else {
                        sessionManager.showConfirm(username: username)
                    }
                })
                Link("View our Privacy Policy", destination: URL(string: "https://adamkali.com/privacy-policy")!)
            }
        }
        .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
