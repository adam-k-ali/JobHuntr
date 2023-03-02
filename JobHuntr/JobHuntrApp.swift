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
import AWSS3StoragePlugin
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
        self.initialUpdate()
        
    }
    
    func initialUpdate() {
        Task {
            print("===========================================================")
            print("Starting Listeners")
            self.setupListeners()
            print("Configuring Amplify")
            self.configureAmplify()
            print("Getting current auth user")
            await sessionManager.getCurrentAuthUser()
            print("Starting DataStore")
            await startDataStore()
            print("===========================================================")
        }
    }
    
    func setupListeners() {
        let _ = Amplify.Hub.listen(to: .dataStore) { event in
            if event.eventName == HubPayload.EventName.DataStore.networkStatus {
                guard let networkStatus = event.data as? NetworkStatusEvent else {
                    print("Failed to cast data as NetworkStatusEvent")
                    return
                }
                print("User receives a network connection status: \(networkStatus.active)")
            }
        }
    }
    
    func configureAmplify() {
        // Configure Amplify
        do {
            // Define sync expressions
            let appSyncExpr = DataStoreSyncExpression.syncExpression(Application.schema) {
                return QueryPredicateConstant.all
            }
            let companySyncExpr = DataStoreSyncExpression.syncExpression(Company.schema) {
                return QueryPredicateConstant.all
            }
            let syncExprs = [appSyncExpr, companySyncExpr]
            
            // Load plugins
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: AmplifyModels(),
                                                       configuration: .custom(syncExpressions: syncExprs))
            )
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            Amplify.Logging.logLevel = .verbose
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
