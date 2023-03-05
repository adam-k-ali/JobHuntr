//
//  ProfileCardView.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/02/2023.
//

import Amplify
import SwiftUI

struct ProfileCardView: View {
    @ObservedObject var sessionManager = SessionManager()

    let user: AuthUser
    @State var streak: Int = 0
    @State var appCount: Int = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: 16.0) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 48.0, height: 48.0)
            Text("\(user.username)")
            Divider()
            HStack {
                Spacer()
                StatCardView(iconName: "flame.fill", title: "Day streak", value: streak)
                Spacer()
                StatCardView(iconName: "tray.full.fill", title: "Applications", value: appCount)
                Spacer()
            }
            .onAppear {
                Task {
                    let applications = await sessionManager.fetchApplicationsByDate(user: user)
                    streak = calculateStreak(applications: applications)
                    appCount = applications.count
                }
            }
//            Text("\(user.firstName) \(user.lastName)")
//                .font(.headline)
//            Text("\(user.occupation)")
        }
    }
    
    func calculateStreak(applications: [Application]) -> Int {
        var streak = 0
        for application in applications {
            let daysSince = Calendar.current.daysSince(date: application.dateApplied!.foundationDate)
            if daysSince - streak > 1 {
                break
            }
            streak += 1
        }
        return streak
    }
}

struct ProfileCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCardView(user: DummyUser())
            .environmentObject(SessionManager())
    }
}
