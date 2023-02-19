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
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Section {
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Sign In", action: {
                    Task {
                        await sessionManager.signIn(username: username, password: password)
                    }
                })
                Spacer()
                Button("Don't have an account? Sign Up.", action: {
                    sessionManager.showSignUp()
                })
            }
            .padding()
//            SignInWithAppleButton(onRequest: configure, onCompletion: handle)
//                .frame(height: 48)
//                .padding()
        }
    }
//
//    func configure(_ request: ASAuthorizationAppleIDRequest) {
//        request.requestedScopes = [.fullName, .email]
//    }
//
//    func handle(_ authResults: Result<ASAuthorization, Error>) {
//        switch authResults {
//        case .success(let auth):
//            switch auth.credential{
//            case let appleIdCreds as ASAuthorizationAppleIDCredential:
//                // Handle authorization
//                if let appleUser = AppleUser(credentials: appleIdCreds) {
//                    // Send to backend
//                    let account = UserAccount(appleUserID: appleUser.userId, firstName: appleUser.firstName, lastName: appleUser.lastName, email: appleUser.email)
//
//                    Task {
//                        await saveUser(account)
//                    }
//                }
//            default:
//                break
//            }
//
//            break
//        case .failure(let error):
//            // Handle error
//            print(error)
//            break
//        }
//    }
    
    func saveUser(_ userAccount: UserAccount) async -> Void {
        do {
            try await Amplify.DataStore.save(userAccount)
        } catch {
            print(error)
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
