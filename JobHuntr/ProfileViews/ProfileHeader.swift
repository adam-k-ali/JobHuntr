//
//  ProfileHeader.swift
//  JobHuntr
//
//  Created by Adam Ali on 29/03/2023.
//

import SwiftUI

struct ProfileHeader: View {
    @EnvironmentObject var userManager: UserManager
    
    var name: String
    
    var body: some View {
        HStack {
            Label(title: {
                Text("**Welcome, \(name)!**")
                    .font(.largeTitle)
            }, icon: {
                ProfilePicture(showEdit: false, size: CGSize(width: 42, height: 42))
                    .environmentObject(userManager)
            })
            Spacer()
        }
    }
}

struct ProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeader(name: "John")
            .environmentObject(UserManager())
    }
}
