//
//  SessionManager.swift
//  JobHuntr
//
//  Created by Adam Ali on 14/02/2023.
//

import Amplify
import Foundation
import SwiftUI

enum AuthState {
    case signUp, login, confirmCode(username: String), session(user: AuthUser)
}

final class SessionManager: ObservableObject {
    @Published var authState: AuthState = .login
    
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
    
    func getCurrentAuthUser() async {
        print("Fetching Auth User")
        
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            
            DispatchQueue.main.async {
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
    
    func signUp(username: String, email: String, password: String) async {
        let attributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: attributes)
        
        do {
            let signUpResult = try await Amplify.Auth.signUp(username: username, password: password, options: options)
            
            if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
                print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId))")
                DispatchQueue.main.async {
                    self.authState = .confirmCode(username: username)
                }
            } else {
                print("SignUp Complete")
            }
        } catch let error as AuthError {
            print("An error occurred while registering a user \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func confirmSignUp(for username: String, with confirmationCode: String) async {
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
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func signIn(username: String, password: String) async {
        do {
            let signInResult = try await Amplify.Auth.signIn(username: username, password: password)
            if signInResult.isSignedIn {
                print("Sign in succeeded")
//                await self.fetchCurrentAuthSession()
                await self.getCurrentAuthUser()
            }
        } catch let error as AuthError {
            print("Sign in failed \(error)")
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
//        await self.clearDataStore()
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
        } catch {
            print("Error querying DataStore - \(error)")
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
        } catch {
            print("Error fetching applications: \(error)")
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
        } catch {
            print("Error finding company: \(error)")
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
        } catch {
            print("Error finding company: \(error)")
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
        } catch {
            print("Couldn't save application: \(error)")
        }
    }
    
    func deleteApplication(application: Application) async {
        do {
            let appKeys = Application.keys
            try await Amplify.DataStore.delete(Application.self, where: appKeys.id == application.id)
        } catch {
            print("Couldn't delete application - \(error)")
        }
    }
    
}
