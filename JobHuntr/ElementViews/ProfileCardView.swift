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
                .aspectRatio(contentMode: .fit)
                .frame(width: 128.0, height: 128.0)
                
            if userManager.profile.givenName.isEmpty || userManager.profile.familyName.isEmpty {
                Text("\(userManager.getUsername())")
                    .font(.headline)
            } else {
                Text("\(userManager.profile.givenName) \(userManager.profile.familyName)")
                    .font(.headline)
            }
            
            if !userManager.profile.jobTitle.isEmpty {
                Text("\(userManager.profile.jobTitle)")
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
