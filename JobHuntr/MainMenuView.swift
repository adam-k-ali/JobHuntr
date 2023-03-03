//
//  MainMenu.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/02/2023.
//

import Amplify
import SwiftUI

struct DummyUser: AuthUser {
    let userId: String = "1"
    let username: String = "dummy"
}

struct MainMenuView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    let user: AuthUser

    
    var body: some View {
        VStack {
            // Profile
            ProfileCardView(user: user)
            
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
        }
        .toolbar {
//            ToolbarItem(placement: .confirmationAction) {
//                Button("Sign Out") {
//                    Task {
//                        await sessionManager.signOut()
//                    }
//                }
//            }
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    print("Show settings")
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
    }
    
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainMenuView(user: DummyUser())
        }
    }
}
