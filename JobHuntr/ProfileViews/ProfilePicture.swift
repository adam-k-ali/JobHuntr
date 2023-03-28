//
//  ProfilePicture.swift
//  JobHuntr
//
//  Created by Adam Ali on 28/03/2023.
//

import SwiftUI

struct ProfilePicture: View {
    @EnvironmentObject var userManager: UserManager
    var body: some View {
        if let profilePic = userManager.profilePic {
            Image(uiImage: profilePic)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                
        }
    }
}

struct ProfilePicture_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePicture()
            .environmentObject(UserManager())
    }
}
