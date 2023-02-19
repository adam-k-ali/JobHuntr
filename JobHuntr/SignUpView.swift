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
    
    var body: some View {
        VStack {
            Spacer()
            Section {
                TextField("Username", text: $username)
                TextField("E-Mail", text: $email)
                SecureField("Password", text: $password)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Sign Up", action: {
                Task {
                    await sessionManager.signUp(username: username, email: email, password: password)
                }
            })
            Spacer()
            Button("Already have an account? Sign In.", action: {
                sessionManager.showLogin()
            })
        }
        .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
