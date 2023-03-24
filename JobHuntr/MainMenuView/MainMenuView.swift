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
        VStack(spacing: 0) {
            ProfileCardView()
                .environmentObject(userManager)
                .frame(height: 300)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(AppColors.primary)
                    .ignoresSafeArea()
                
                VStack {
                    UserStatsDashboardView()
                        .environmentObject(userManager)
                    MenuButtons()
                    Spacer()
                }
                .padding()
                
                
                
            }
            .padding(.top, -20)
            
            
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
                .environmentObject(UserManager(username: "Dummy", userId: ""))
        }
    }
}
