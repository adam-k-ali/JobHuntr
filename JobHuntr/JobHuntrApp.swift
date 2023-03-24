//
//  JobHuntrApp.swift
//  JobHuntr
//
//  Created by Adam Ali on 10/02/2023.
//

import Amplify
import AWSDataStorePlugin
import AWSCognitoAuthPlugin
import AWSAPIPlugin
import AWSS3StoragePlugin
import UserNotifications
import AWSPinpoint
import SwiftUI

@main
struct JobHuntrApp: App {
    @ObservedObject var sessionManager = SessionManager()
    @ObservedObject var launchManager = LaunchScreenStateManager()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                if launchManager.isActive() {
                    LoadingView()
                } else {
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
                    case .session(let username, let userId):
                        ContentView()
                            .environmentObject(sessionManager)
                            .environmentObject(UserManager(username: username, userId: userId))
                    case .confirmReset(let username):
                        ResetConfirmationView(username: username)
                            .environmentObject(sessionManager)
                    case .resetPassword:
                        ResetPasswordView()
                            .environmentObject(sessionManager)
                    }
                    SignUpView()
                }
            }
        }
    }
    
    init() {
        self.initialUpdate()
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
//        sessionManager.requestNotificationPermissions()
        launchManager.dismiss()
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
        let _ = Amplify.Hub.listen(to: .dataStore) { result in
            switch result.eventName {
            case HubPayload.EventName.DataStore.networkStatus:
                guard let networkStatus = result.data as? NetworkStatusEvent else {
                    print("Failed to cast data as NetworkStatusEvent")
                    return
                }
                print("User receives a network connection status: \(networkStatus.active)")
            case HubPayload.EventName.DataStore.syncStarted:
                print("Sync started")
            case HubPayload.EventName.DataStore.syncReceived:
                print("Sync received")
            case HubPayload.EventName.DataStore.modelSynced:
                print("Model synced")
            default:
                break
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
//            Amplify.Logging.logLevel = .verbose
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
