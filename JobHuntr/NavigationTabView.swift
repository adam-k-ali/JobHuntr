//
//  NavigationTabView.swift
//  JobHuntr
//
//  Created by Adam Ali on 27/03/2023.
//

import SwiftUI

struct NavigationTabView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var userManager: UserManager
    
    @State var tabSelection = 2
    
    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationView {
                ApplicationsView()
                    .environmentObject(userManager)
            }
            .tabItem {
                Label("Applications", systemImage: "list.bullet.clipboard")
            }
            .tag(1)
            
            NavigationView {
                ProfileView(name: $userManager.profile.givenName)
                    .environmentObject(userManager)
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
            .tag(2)
            
            NavigationView {
                SettingsView()
                    .environmentObject(sessionManager)
                    .environmentObject(userManager)
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
            .tag(3)
        }
    }
}

struct NavigationTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationTabView()
            .environmentObject(SessionManager())
            .environmentObject(UserManager())
    }
}
