//
//  ContentView.swift
//  JobHuntr
//
//  Created by Adam Ali on 10/02/2023.
//

import AuthenticationServices
import Amplify
import SwiftUI

struct AppleUser: Codable {
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
    
    init?(credentials: ASAuthorizationAppleIDCredential) {
        guard
            let firstName = credentials.fullName?.givenName,
            let lastName = credentials.fullName?.familyName,
            let email = credentials.email
        else { return nil }
        
        self.userId = credentials.user
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}

enum LoginState {
    case idle, loading
}

struct LoginView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var username = ""
    @State var password = ""
    @State var error: String = ""
    
    @State var state: LoginState = .idle
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 8.0))
                .frame(width: 128, height: 128)
            Spacer()
            if state == .loading {
                ProgressCircle()
                    .frame(width: 48.0, height: 48.0)
                    .padding(20)
            }
            // Login Form
            Section {
                
                Text(error)
                    .font(.headline)
                    .foregroundColor(.red)
                TextField("Username", text: $username)
                    .textFieldStyle(GradientTextFieldBackground(systemImageString: "person"))
                SecureField("Password", text: $password)
                    .textFieldStyle(GradientTextFieldBackground(systemImageString: "key"))
            }
            
            
            Button(action: signIn, label: {
                Text("Login")
            })
            .buttonStyle(PrimaryButtonStyle())
            
            Button(action: {
                sessionManager.showResetPassword()
            }, label: {
                Text("Forgotten Password")
            })
            .buttonStyle(SecondaryButtonStyle())
            
            Spacer()
            Button(action: {
                sessionManager.showSignUp()
            }, label: {
                Text("Don't have an account? Sign Up.")
            })
        }
        .padding()
        
    }
    
    func signIn() {
        Task {
            state = .loading
            await sessionManager.signIn(username: username, password: password, errorMsg: $error) {
                state = .idle
            }
        }
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
                .environmentObject(SessionManager())
        }
    }
}
