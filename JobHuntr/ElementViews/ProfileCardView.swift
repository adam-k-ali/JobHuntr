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
        ZStack {
//            AppColors.background
//                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(AppColors.background)
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 12) {
                ZStack {
                    if let profilePic = userManager.profilePic {
                        Image(uiImage: profilePic)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .frame(width: 128.0, height: 128.0)
                            
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 128.0, height: 128.0)
                            .foregroundColor(AppColors.fontColor)
                    }
                }
                .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: -2)
                
                if userManager.profile.givenName.isEmpty || userManager.profile.familyName.isEmpty {
                    Text("\(userManager.getUsername())")
                        .font(.headline)
                        .foregroundColor(AppColors.fontColor)
                } else {
                    Text("\(userManager.profile.givenName) \(userManager.profile.familyName)")
                        .font(.headline)
                        .foregroundColor(AppColors.fontColor)
                }
                
                if !userManager.profile.jobTitle.isEmpty {
                    Text("\(userManager.profile.jobTitle)")
                        .foregroundColor(AppColors.fontColor)
                }
            }
            .padding(0)
        }
    }
    
}

struct ProfileCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCardView()
            .environmentObject(UserManager())
    }
}
