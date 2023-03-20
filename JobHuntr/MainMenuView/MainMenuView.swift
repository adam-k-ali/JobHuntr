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
        ZStack {
            // Set background color
            AppColors.primary
                .ignoresSafeArea()
                // Profile
                ZStack {
                    ProfileCardView()
                        .environmentObject(userManager)
                        .padding(.top, -500)
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(AppColors.primary)
//                            .frame(height: 128)
                            .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: -2)
                        
                        VStack {
                            UserStatsDashboardView()
                                .environmentObject(userManager)
                            MenuButtons()
                            Spacer()
                        }
                        .padding()
                        
                    }
                    .padding(.top, 300)
                }
                .ignoresSafeArea()
        }
//        .onAppear {
//            if (ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1") {
//                return
//            }
//        }
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
