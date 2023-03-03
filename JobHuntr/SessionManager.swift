//
//  SessionManager.swift
//  JobHuntr
//
//  Created by Adam Ali on 14/02/2023.
//

import Amplify
import Foundation
import SwiftUI

struct DummyUser: AuthUser {
    let userId: String = "1"
    let username: String = "dummy"
}

enum AuthState {
    case signUp, login, confirmCode(username: String), session(user: AuthUser)
}

class SessionManager: ObservableObject {
    @Published var authState: AuthState = .login
    @Published var userSettings: UserSettings = UserSettings(userID: "", colorBlind: false)
    
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
    
    func fetchUserSettings(user: AuthUser) async {
        do {
            let settings = try await Amplify.DataStore.query(UserSettings.self, where: UserSettings.keys.userID == user.userId)
            if settings.isEmpty {
                print("No settings found. Using defaults.")
                self.userSettings = UserSettings(userID: user.userId, colorBlind: false)
                return
            }
            self.userSettings = settings[0]
        } catch let error as DataStoreError {
            print("Error fetching user settings - \(error)")
        } catch {
            print("Unexpected error - \(error)")
        }
    }
    
    func getCurrentAuthUser() async {
        print("Fetching Auth User")
        
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            await self.fetchUserSettings(user: user)
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
    
    func showSignUp() {
        authState = .signUp
    }
    
    func showLogin() {
        authState = .login
    }
    
    func showConfirm(username: String) {
        authState = .confirmCode(username: username)
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
    
    func fetchApplication(id: String) async -> Application? {
        print("Fetching Application: \(id)")
        do {
            let application = try await Amplify.DataStore.query(Application.self, byId: id)
            return application
        } catch let error as DataStoreError {
            print("Error querying DataStore for application \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
        return nil
    }
    
    func fetchAllApplications(_ user: AuthUser) async -> [Application] {
        print("Fetching user applications. UserID: \(user.userId)")
        let k = Application.keys
        do {
            let applications = try await Amplify.DataStore.query(Application.self, where: k.userID == user.userId)
            print("\(applications.count) applications found.")
            return applications
        } catch let error as DataStoreError {
            print("Error fetching user's applications \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
        return []
    }
    
    func fetchCompany(_ companyID: String) async -> Company? {
        let companyKeys = Company.keys
        do {
            
            let company = try await Amplify.DataStore.query(Company.self, where: companyKeys.id == companyID)
            if company.isEmpty {
                return nil
            }
            return company[0]
        } catch let error as DataStoreError {
            print("Error finding company \(error)")
        } catch {
            print("Unexpected Error \(error)")
        }
        return nil
    }
    
    func findCompanyByName(_ companyName: String) async -> Company? {
        let companyKeys = Company.keys
        do {
            let company = try await Amplify.DataStore.query(Company.self, where: companyKeys.name == companyName)
            if company.isEmpty {
                return nil
            }
            return company[0]
        } catch let error as DataStoreError {
            print("Error finding company by name \(error)")
        } catch {
            print("Unexpected Error \(error)")
        }
        return nil
    }
    
    func saveApplication(application: Binding<Application>, company: Company) async {
        do {
            print("Saving application - \(application.wrappedValue)")
            
            // Check if there exists a company with the same name already.
            if let company = await findCompanyByName(company.name) {
                application.wrappedValue.companyID = company.id
            } else {
                // Save the company
                try await Amplify.DataStore.save(company)
                application.wrappedValue.companyID = company.id
            }
            
            // Save the application
            try await Amplify.DataStore.save(application.wrappedValue)
        } catch let error as DataStoreError {
            print("Error Saving Application \(error)")
        } catch {
            print("Unexpected Error \(error)")
        }
    }
    
    func deleteApplication(application: Application) async {
        do {
            try await Amplify.DataStore.delete(application)
        } catch let error as DataStoreError {
            print("Error Deleting Application \(error)")
        } catch {
            print("Unexpected Error \(error)")
        }
    }
    
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
    
    func saveSettings() async {
        do {
            try await Amplify.DataStore.save(userSettings)
        } catch let error as DataStoreError {
            print("Saving settings failed - \(error)")
        } catch {
            print("Unexppected Error \(error)")
        }
    }
    
}
