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
            StatCardView(title: "Day streak", value: $userManager.streak) {
                Image(systemName: "flame.fill")
                    .foregroundColor(Color(uiColor: .systemOrange))
            }
            Spacer()
            StatCardView(title: "Applications", value: $userManager.numApplications) {
                Image(systemName: "tray.full.fill")
                    .foregroundColor(AppColors.fontColor)
            }
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
