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
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack(spacing: 16) {
                Spacer()
                Image(uiImage: UIImage(named: "AppLogo") ?? UIImage())
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .frame(width: 128, height: 128)
                Spacer()
                Section {
                    TextField("Username", text: $username)
                        .textFieldStyle(GradientTextFieldBackground(systemImageString: "person"))
                    
                    TextField("E-Mail", text: $email)
                        .textFieldStyle(GradientTextFieldBackground(systemImageString: "envelope"))
                    
                    SecureInputView("Password", text: $password)
                        .textFieldStyle(GradientTextFieldBackground(systemImageString: "key"))
                    
                    SecureInputView("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(GradientTextFieldBackground(systemImageString: "key"))
                    Text(error)
                        .font(.headline)
                        .foregroundColor(.red)
                }
                
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
                .buttonStyle(PrimaryButtonStyle())
                
                if isLoading {
                    ProgressView()
                }
                Spacer()
                VStack(spacing: 12) {
                    HStack {
                        Text("Already have an account?")
                            .font(.headline)
                        Button("Sign In.", action: {
                            sessionManager.showLogin()
                        })
                        .foregroundColor(Color(uiColor: UIColor.systemBlue))
                    }
                    Spacer()
                    
                    
                    
                    HStack {
                        Text("View our")
                            .font(.headline)
                        
                        Link("Privacy Policy", destination: URL(string: "https://adamkali.com/privacy-policy")!)
                            .foregroundColor(Color(uiColor: UIColor.systemBlue))
                    }
                    
                    Button("Enter Confirmation Code", action: {
                        if username.isEmpty {
                            error = "To confirm, enter username."
                        } else {
                            sessionManager.showConfirm(username: username)
                        }
                    })
                    .foregroundColor(Color(uiColor: UIColor.systemBlue))
                }
            }
            .padding()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
