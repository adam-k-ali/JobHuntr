//
//  ProfileCardView.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/02/2023.
//

import Amplify
import SwiftUI

struct ProfileCardView: View {
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        VStack(alignment: .center, spacing: 16.0) {
            Image(uiImage: userManager.profilePic)
                .resizable()
                .clipShape(Circle())
                .frame(width: 128.0, height: 128.0)
                
            if userManager.profile.givenName.isEmpty || userManager.profile.lastName.isEmpty {
                Text("\(userManager.getUsername())")
                    .font(.headline)
            } else {
                Text("\(userManager.profile.givenName) \(userManager.profile.lastName)")
                    .font(.headline)
            }
            
            if !userManager.profile.jobTitle.isEmpty {
                Text("\(userManager.profile.jobTitle)")
            }
            
            Divider()
            HStack {
                Spacer()
                StatCardView(iconName: "flame.fill", title: "Day streak", value: $userManager.streak)
                Spacer()
                StatCardView(iconName: "tray.full.fill", title: "Applications", value: $userManager.numApplications)
                Spacer()
            }
        }
    }
    
}

struct ProfileCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCardView()
            .environmentObject(UserManager(user: DummyUser()))
    }
}
