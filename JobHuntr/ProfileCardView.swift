//
//  ProfileCardView.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/02/2023.
//

import Amplify
import SwiftUI

struct ProfileCardView: View {
    let user: AuthUser
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 48.0, height: 48.0)
            Text("\(user.username)")
//            Text("\(user.firstName) \(user.lastName)")
//                .font(.headline)
//            Text("\(user.occupation)")
        }
    }
}

//struct ProfileCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileCardView(user: DummyUser())
//            .environmentObject(DummySessionManager())
//    }
//}
