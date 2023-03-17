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

struct DummyUser: AuthUser {
    let userId: String = "1"
    let username: String = "dummy"
}

enum AuthState {
    case signUp, login, confirmCode(username: String), session(user: AuthUser), confirmReset(username: String), resetPassword
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
    
    func fetchCurrentAuthSession() async {
        print("Fetching Auth Session")
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            print("Is user signed in - \(session.isSignedIn)")
        } catch let error as AuthError {
            print("Fetch session failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    /**
     Fetch the AuthUser.
     Called when the user signs in.
     */
    func getCurrentAuthUser() async {
        print("Fetching Auth User")
        
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            
            DispatchQueue.main.async {
                // Update auth state
                self.authState = .session(user: user)
            }
        } catch {
            print(error)
            DispatchQueue.main.async {
                self.authState = .login
            }
        }
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
    
    func signIn(username: String, password: String, errorMsg: Binding<String>) async {
        do {
            let signInResult = try await Amplify.Auth.signIn(username: username, password: password)
            if signInResult.isSignedIn {
                print("Sign in succeeded")
//                await self.fetchCurrentAuthSession()
                await self.getCurrentAuthUser()
                await self.startDataStore()
            }
            
        } catch let error as AuthError {
            print("Sign in failed \(error)")
            errorMsg.wrappedValue = error.errorDescription
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func signOut() async {
        // Sign Out
        let _ = await Amplify.Auth.signOut()
        
        // Update user state
        await self.getCurrentAuthUser()
        
        // Clear DataStore
        await self.clearDataStore()
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