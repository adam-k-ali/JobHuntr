//
//  UserStatsDashboardView.swift
//  JobHuntr
//
//  Created by Adam Ali on 17/03/2023.
//

import SwiftUI

struct UserStatsDashboardView: View {
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        HStack {
            Spacer()
            StatCardView(iconName: "flame.fill", title: "Day streak", value: $userManager.streak)
            Spacer()
            StatCardView(iconName: "tray.full.fill", title: "Applications", value: $userManager.numApplications)
            Spacer()
        }
    }
}

struct UserStatsDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        UserStatsDashboardView()
            .environmentObject(UserManager(user: DummyUser()))
    }
}
