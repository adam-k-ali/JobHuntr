//
//  MenuButtons.swift
//  JobHuntr
//
//  Created by Adam Ali on 19/03/2023.
//

import SwiftUI

struct MenuButtons: View {
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        VStack {
            Section {
                NavigationLink(destination: {
                    ProfileView()
                        .environmentObject(userManager)
                }) {
                    MenuButtonView(iconName: "person.crop.circle.fill", title: "Your Profile")
                }
                .buttonStyle(.plain)
                
                NavigationLink(destination: {
                    ApplicationsView()
                        .environmentObject(userManager)
                }) {
                    MenuButtonView(iconName: "tray.full.fill", title: "Your Job Applications")
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct MenuButtons_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtons()
            .environmentObject(UserManager(user: DummyUser()))
    }
}
