//
//  ProfilePicture.swift
//  JobHuntr
//
//  Created by Adam Ali on 28/03/2023.
//

import SwiftUI

struct ProfilePicture: View {
    @EnvironmentObject var userManager: UserManager
    @State var showEdit: Bool = false
    @State var size: CGSize
    
    var body: some View {
        ZStack(alignment: .top) {
            if let profilePic = userManager.profilePic {
                Image(uiImage: profilePic)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
            }
            
            if showEdit {
                ZStack {
                    Rectangle()
                        .opacity(0.5)
                        .frame(width: 12, height: 12)
                    Text("Edit")
                        .font(.callout)
                        .foregroundColor(.white)
                        .opacity(0.9)
                }
                .padding(.top, size.height - 15)
            }
        }
        .clipShape(Circle())
        .frame(width: size.width, height: size.height)
    }
}

struct ProfilePicture_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePicture(size: CGSize(width: 128, height: 128))
            .environmentObject(UserManager())
    }
}
