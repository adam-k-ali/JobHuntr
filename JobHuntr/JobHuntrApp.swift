//
//  JobHuntrApp.swift
//  JobHuntr
//
//  Created by Adam Ali on 10/02/2023.
//

import Amplify
import AWSDataStorePlugin
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
import AWSAPIPlugin
import SwiftUI

@main
struct JobHuntrApp: App {
    @ObservedObject var sessionManager = SessionManager()

    var body: some Scene {
        WindowGroup {
            NavigationView {
//                LoginView(user: $store.user)
                switch sessionManager.authState {
                case .login:
                    LoginView()
                        .environmentObject(sessionManager)
                case .signUp:
                    SignUpView()
                        .environmentObject(sessionManager)
                case .confirmCode(let username):
                    ConfirmationView(username: username)
                        .environmentObject(sessionManager)
                case .session(let user):
                    MainMenuView(user: user)
                        .environmentObject(sessionManager)
                }
                SignUpView()
            }
        }
    }
    
    init() {
        self.configureAmplify()
        self.initialUpdate()
        
    }
    
    func initialUpdate() {
        Task {
            await sessionManager.getCurrentAuthUser()
            await startDataStore()
        }
    }
    
    func configureAmplify() {
        // Configure Amplify
        do {
            let appSyncExpr = DataStoreSyncExpression.syncExpression(Application.schema) {
                return QueryPredicateConstant.all
            }
            let companySyncExpr = DataStoreSyncExpression.syncExpression(Company.schema) {
                return QueryPredicateConstant.all
            }
            
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: AmplifyModels(),
                                                       configuration: .custom(syncExpressions: [appSyncExpr, companySyncExpr]))
            )
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure()
            print("Amplify configured.")
            
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }
    }
    
    func startDataStore() async {
        do {
            try await Amplify.DataStore.start()
            print("DataStore Started")
        } catch let error as DataStoreError {
            print("Failed with error \(error)")
        } catch {
            print("Unexpected Error \(error)")
        }
    }
}
