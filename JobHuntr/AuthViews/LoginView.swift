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

struct LoginView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var username = ""
    @State var password = ""
    @State var error: String = ""
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                    .resizable()
                    .frame(width: 128, height: 128)
                Spacer()
                    .frame(minHeight: 10, idealHeight: 100, maxHeight: 600)
                    .fixedSize()
                Section {
                    Text(error)
                        .font(.headline)
                        .foregroundColor(.red)
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                    
                    
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack {
                    Button("Forgotton Password", action: {
                        sessionManager.showResetPassword()
                    })
                    Spacer()
                    Button("Sign In", action: {
                        isLoading = true
                        Task {
                            await sessionManager.signIn(username: username, password: password, errorMsg: $error)
                        }
                        isLoading = false
                    })
                }
                if isLoading {
                    ProgressView()
                }
                
                Spacer()
                Button("Don't have an account? Sign Up.", action: {
                    sessionManager.showSignUp()
                })
            }
            .padding()
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}
