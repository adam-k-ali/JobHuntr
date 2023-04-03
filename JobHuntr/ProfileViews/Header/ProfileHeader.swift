//
//  ProfileHeader.swift
//  JobHuntr
//
//  Created by Adam Ali on 29/03/2023.
//

import SwiftUI

struct ProfileHeader: View {
    @EnvironmentObject var userManager: UserManager
    
    @ObservedObject var profileManager: UserProfileManager
    
    var name: String
    
    var body: some View {
        HStack {
            Label(title: {
                Text("**Welcome, \(name)!**")
                    .font(.largeTitle)
            }, icon: {
                ProfilePicture(profileManager: profileManager, size: CGSize(width: 42, height: 42), showEdit: false)
//                    .environmentObject(userManager)
            })
            Spacer()
        }
    }
}

struct ProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeader(profileManager: UserProfileManager(), name: "John")
            .environmentObject(UserManager())
    }
}
