//
//  PreAuthNavView.swift
//  JobHuntr
//
//  Created by Adam Ali on 01/04/2023.
//

import SwiftUI

struct PreAuthNavView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var launchManager: LaunchStateManager
    
    @State var tabSelection = 1
    
    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationView {
                LoginView()
                    .environmentObject(sessionManager)
                    .environmentObject(userManager)
                    .environmentObject(launchManager)
            }
            .tabItem {
                Label("Login", systemImage: "list.bullet.clipboard")
            }
            .tag(1)
            
            NavigationView {
                SettingsView()
                    .environmentObject(sessionManager)
                    .environmentObject(userManager)
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
            .tag(2)
        }
    }
}

struct PreAuthNavView_Previews: PreviewProvider {
    static var previews: some View {
        PreAuthNavView()
            .environmentObject(SessionManager())
            .environmentObject(UserManager())
            .environmentObject(LaunchStateManager())
    }
}
