//
//  MainMenu.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/02/2023.
//

import Amplify
import SwiftUI

/**
 The main view for a session.
 */
struct MainMenuView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var userManager: UserManager
        
    var body: some View {
        VStack {
            // Profile
            ProfileCardView()
                .environmentObject(userManager)
            
            Divider()
            
            List {
                Section {
                    NavigationLink(destination: {
                        ApplicationsView()
                            .environmentObject(userManager)
                    }) {
                        MenuButtonView(iconName: "tray.full.fill", title: "Your Job Applications")
                    }
                }
                Spacer()
                Section {
                    NavigationLink(destination: {
                        Text("Test")
                    }) {
                        MenuButtonView(iconName: "newspaper.fill", title: "Submit Feedback")
                            .foregroundColor(.red)
                    }
                }
            }
            .listStyle(.plain)
            Divider()
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                NavigationLink(destination: {
                    NavigationView {
                        SettingsView()
                            .environmentObject(sessionManager)
                            .environmentObject(userManager)
                    }
                }, label: {
                    Image(systemName: "gearshape")
                })
            }
        }
    }
    
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainMenuView()
                .environmentObject(SessionManager())
                .environmentObject(UserManager(user: DummyUser()))
        }
    }
}
