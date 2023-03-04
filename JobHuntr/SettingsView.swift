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
            // Accessibility
            Section {
                Toggle(isOn: $settings.colorBlind, label: {
                    Text("Color Blindness")
                })
            }
            
            // Account
            Section {
                Button("Sign Out") {
                    Task {
                        await sessionManager.signOut()
                    }
                }
            }
        }
        .padding()
        .onDisappear {
            Task {
                await sessionManager.saveSettings()
            }
        }
    }
}

//struct SettingsViewq_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
