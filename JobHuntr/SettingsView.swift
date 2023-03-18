//
//  SettingsViewq.swift
//  JobHuntr
//
//  Created by Adam Ali on 03/03/2023.
//

import SwiftUI
import Amplify

struct SettingsView: View {
//    @State private var settings: UserSettings
    
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var userManager: UserManager
    
    @State var showFeedbackForm: Bool = false
    
    var body: some View {
        List {
            // Accessibility
            Section(header: Text("Accessibility")) {
                Toggle(isOn: $userManager.settings.colorBlind, label: {
                    Text("Colour Blindness")
                })
            }
            
            // Account
            Section(header: Text("Account Management")) {
                Button("Sign Out") {
                    Task {
                        await sessionManager.signOut()
                    }
                }
            }
            
            // Other
            Section(header: Text("Other")) {
                Button {
                    showFeedbackForm = true
                } label: {
                    Text("Send Feedback")
                }
            }
        }
        .onDisappear {
            Task {
                await userManager.saveUserSettings()
            }
        }
        .sheet(isPresented: $showFeedbackForm) {
            NavigationView {
                FeedbackView()
                    .environmentObject(userManager)
            }
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
                .environmentObject(SessionManager())
                .environmentObject(UserManager(user: DummyUser()))
        }
    }
}
