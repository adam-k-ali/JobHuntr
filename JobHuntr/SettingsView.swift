//
//  SettingsViewq.swift
//  JobHuntr
//
//  Created by Adam Ali on 03/03/2023.
//

import SwiftUI
import Amplify

struct SettingsView: View {
    @Binding var settings: UserSettings
    
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        VStack {
            List {
                // Accessibility
                Section(header: Text("Accessibility")) {
                    Toggle(isOn: $settings.colorBlind, label: {
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
            }
        }
        .onDisappear {
            Task {
                await sessionManager.saveSettings()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settings: .constant(UserSettings(userID: "", colorBlind: false)))
            .environmentObject(SessionManager())
    }
}
