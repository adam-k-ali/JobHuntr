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

    @State var showingEditView: Bool = false
        
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                ProfilePicture(profileManager: profileManager, size: CGSize(width: 64, height: 64), showEdit: false)
                Group {
                    Text("\(profileManager.profile.givenName) \(profileManager.profile.familyName)")
                        .font(.headline)
                    if !profileManager.profile.jobTitle.isEmpty {
                        Text(profileManager.profile.jobTitle)
                    }
                }
            }
        
            Spacer()
            Button(action: {
                showingEditView = true
            }, label: {
                Image(systemName: "pencil")
                    .resizable()
                    .frame(width: 20, height: 20)
            })
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $showingEditView) {
            NavigationView {
                EditProfileView(profileManager: profileManager)
                //                .environmentObject(userManager)
            }
        }
    }
}

struct ProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeader(profileManager: UserProfileManager(profile: Profile(userID: "", givenName: "John", familyName: "Doe", profilePicture: "", jobTitle: "Software Engineer", about: "")))
            .environmentObject(UserManager())
    }
}
