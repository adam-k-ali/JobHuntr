//
//  SessionManager.swift
//  JobHuntr
//
//  Created by Adam Ali on 14/02/2023.
//

import Amplify
import Foundation
import SwiftUI
import AWSCognitoAuthPlugin
import AWSPluginsCore

struct DummyUser: AuthUser {
    let userId: String = ""
    let username: String = "dummy"
}

enum AuthState {
    case signUp, login, confirmCode(username: String), session(username: String, userId: String), confirmReset(username: String), resetPassword
}

class SessionManager: ObservableObject {
    // The session's state
    @Published var authState: AuthState = .login
        
    func showSignUp() {
        authState = .signUp
    }
    
    func showLogin() {
        authState = .login
    }
    
    func showConfirm(username: String) {
        authState = .confirmCode(username: username)
    }
    
    func showResetPassword() {
        authState = .resetPassword
    }
    
    func showConfirmReset(username: String) {
        authState = .confirmReset(username: username)
    }

    /**
     Fetches the current session's user id.
        - returns the user id, or nil if there is no user signed in.
     */
    func fetchCurrentAuthSession() async -> String? {
        print("Fetching Auth Session")
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            
            // Get user sub or identity id
            if let identityProvider = session as? AuthCognitoIdentityProvider {
                let usersub = try identityProvider.getUserSub().get()
                let identityId = try identityProvider.getIdentityId().get()
                
                print("User sub - \(usersub) and identity id \(identityId)")
                return usersub
            }
//
//            // Get AWS credentials
//            if let awsCredentialsProvider = session as? AuthAWSCredentialsProvider {
//                let credentials = try awsCredentialsProvider.getAWSCredentials().get()
//                // Do something with the credentials
//
//            }
//
//            // Get cognito user pool token
//            if let cognitoTokenProvider = session as? AuthCognitoTokensProvider {
//                let tokens = try cognitoTokenProvider.getCognitoTokens().get()
//                // Do something with the JWT tokens
//            }
//            print("Is user signed in - \(session.isSignedIn)")
        } catch let error as AuthError {
            print("Fetch session failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
        return nil
    }

    /**
     Fetch the AuthUser.
     Called when the user signs in.
     */
    func getCurrentAuthUser() async -> AuthUser? {
        print("Fetching Auth User")
        
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            
            let userId = await self.fetchCurrentAuthSession()
            
            DispatchQueue.main.async {
                // Update auth state
                self.authState = .session(username: user.username, userId: userId ?? user.userId)
            }
            print("User fetched")
            return user
        } catch {
            print(error)
            DispatchQueue.main.async {
                self.authState = .login
            }
        }
        return nil
    }
    
    func confirmResetPassword(username: String, newPassword: String, confirmationCode: String, errorMsg: Binding<String>) async {
        do {
            try await Amplify.Auth.confirmResetPassword(
                for: username,
                with: newPassword,
                confirmationCode: confirmationCode
            )
            print("Password reset confirmed")
        } catch let error as AuthError {
            print("Reset password failed with error \(error)")
            errorMsg.wrappedValue = error.errorDescription
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func resetPassword(username: String, errorMsg: Binding<String>) async {
        do {
            let resetResult = try await Amplify.Auth.resetPassword(for: username)
            switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                    print("Confirm reset password with code send to - \(deliveryDetails) \(String(describing: info))")
                case .done:
                    print("Reset completed")
            }
        } catch let error as AuthError {
            print("Reset password failed with error \(error)")
            switch (error.underlyingError as? AWSCognitoAuthError) {
            case .userNotFound:
                errorMsg.wrappedValue = "User Not Found"
            case .invalidParameter:
                errorMsg.wrappedValue = "Invalid Parameter"
            default:
                errorMsg.wrappedValue = error.errorDescription
            }
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func signUp(username: String, email: String, password: String, errorMsg: Binding<String>) async {
        let attributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: attributes)
        
        do {
            let signUpResult = try await Amplify.Auth.signUp(username: username, password: password, options: options)
            
            if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
                print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId))")
                DispatchQueue.main.async {
                    self.showConfirm(username: username)
                }
            } else {
                print("SignUp Complete")
            }
        } catch let error as AuthError {
            print("An error occurred while registering a user \(error)")
            errorMsg.wrappedValue = error.errorDescription
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func confirmSignUp(for username: String, with confirmationCode: String, errorMsg: Binding<String>) async {
        do {
            let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
                for: username,
                confirmationCode: confirmationCode
            )
            
            if confirmSignUpResult.isSignUpComplete {
                DispatchQueue.main.async {
                    self.showLogin()
                }
            }
            print("Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")
        } catch let error as AuthError {
            print("An error occurred while confirming sign up \(error)")
            errorMsg.wrappedValue = error.errorDescription
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func signIn(username: String, password: String, errorMsg: Binding<String>, completion: () -> Void) async {
        do {
            let signInResult = try await Amplify.Auth.signIn(username: username, password: password)
            if signInResult.isSignedIn {
                print("Sign in succeeded")
//                await self.fetchCurrentAuthSession()
                let _ = await self.getCurrentAuthUser()
                await self.startDataStore()
            }
        } catch let error as AuthError {
            print("Sign in failed \(error)")
            errorMsg.wrappedValue = error.errorDescription
        } catch {
            print("Unexpected error: \(error)")
        }
        completion()
    }
    
    func signOut() async {
        // Sign Out
        let _ = await Amplify.Auth.signOut()
        
        // Update user state
        let _ = await self.getCurrentAuthUser()
        
        // Clear DataStore
//        await self.clearDataStore()
    }
    
    func deleteUser() async {
        do {
            // Get current user
            let user = await self.getCurrentAuthUser()
            if user == nil {
                print("User not signed in")
                return
            }
            
            // Delete user information
            try await Amplify.DataStore.delete(UserSkills.self, where: UserSkills.keys.userID == user!.userId)
            try await Amplify.DataStore.delete(Profile.self, where: Profile.keys.userID == user!.userId)
            try await Amplify.DataStore.delete(Job.self, where: Job.keys.userID == user!.userId)
            try await Amplify.DataStore.delete(Education.self, where: Education.keys.userID == user!.userId)
            try await Amplify.DataStore.delete(Application.self, where: Application.keys.userID == user!.userId)
            try await Amplify.DataStore.delete(UserSettings.self, where: UserSettings.keys.userID == user!.userId)
            await self.clearDataStore()
            
            try await Amplify.Auth.deleteUser()
            print("Successfully deleted user")
        } catch let error as AuthError {
            print("Delete user failed with error \(error)")
        } catch let error as DataStoreError {
            print("Delete user failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func clearDataStore() async {
        do {
            try await Amplify.DataStore.stop()
            try await Amplify.DataStore.clear()
        } catch let error as DataStoreError {
            print("Error clearing DataStore \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
    }

    /**
        Starts the DataStore instance
     */
    func startDataStore() async {
        do {
            try await Amplify.DataStore.stop()
            try await Amplify.DataStore.start()
            print("DataStore Started")
        } catch let error as DataStoreError {
            print("Starting DataStore failed with error \(error)")
        } catch {
            print("Unexpected Error \(error)")
        }
    }
    
    /**
        Requests permissions to send push-notifications to the user.
     */
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                self.scheduleNotification()
                print("All set")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    /**
        Schedules notifications to send to the user.
     */
    func scheduleNotification() {
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Job Applications"
        content.body = "Add a Job Application now to extend your streak!"
        
        // Create trigger at 19:00 hours
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = 19 // 19:00 hrs
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        // Schedule the request
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
