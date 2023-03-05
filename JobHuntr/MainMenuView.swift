//
//  MainMenu.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/02/2023.
//

import Amplify
import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    let user: AuthUser
    
    var body: some View {
        VStack {
            // Profile
            ProfileCardView(user: user)
                .environmentObject(sessionManager)
//            Divider()
            MenuButton(iconName: "tray.full.fill", title: "Your Job Applications", onClick: {})
            List {
                Section {
                    NavigationLink(destination: {
                        ApplicationsView(user: user)
                            .environmentObject(sessionManager)
                    }) {
                        Text("Your Job Applications")
                    }
                }
                
            }
            .listStyle(InsetGroupedListStyle())
            Divider()
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                NavigationLink(destination: {
                    SettingsView(settings: $sessionManager.userSettings)
                        .environmentObject(sessionManager)
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
            MainMenuView(user: DummyUser())
                .environmentObject(SessionManager())
        }
    }
}
