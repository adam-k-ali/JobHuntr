//
//  SettingsViewq.swift
//  JobHuntr
//
//  Created by Adam Ali on 03/03/2023.
//

import SwiftUI
import Amplify

struct SettingsView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var userManager: UserManager
    
    @State var showFeedbackForm: Bool = false
    @State var showingDeleteAccount: Bool = false
    
    var body: some View {
        List {
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
                Link("Privacy Policy", destination: URL(string: "https://adamkali.com/privacy-policy")!)
            }
            
            Section {
                Button("Delete Account") {
                    Task {
                        showingDeleteAccount = true
                    }
                }
                .foregroundColor(.red)
            }
        }
        .actionSheet(isPresented: $showingDeleteAccount) {
            // Confirmation of deletion
            ActionSheet(title: Text("Delete Account?"), message: Text("Are you sure you want to delete your account?"), buttons: [
                .destructive(Text("Delete"), action: {
                    Task {
                        await sessionManager.deleteUser()
                    }
                }),
                .cancel()
            ])
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
                .environmentObject(UserManager())
        }
    }
}
