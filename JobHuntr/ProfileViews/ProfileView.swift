//
//  ProfileView.swift
//  JobHuntr
//
//  Created by Adam Ali on 17/03/2023.
//

import SwiftUI
import Amplify



struct ProfileView: View {
    enum ProfileAction: String, Identifiable {
        case newEducation, newJob, editProfile
        
        var id: String {
            return self.rawValue
        }
    }
    
    @EnvironmentObject var userManager: UserManager
    
    @State var selectedEducation: Education?
    @State var showingEditView: Bool = false
        
    @ObservedObject var profileManager: UserProfileManager

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack {
                ProfileHeader(profileManager: profileManager)
                    .environmentObject(userManager)
                    .padding()
                    .padding(.horizontal)
                Divider()
                    .padding(.horizontal)
                cvView
                    .padding()
            }
        }
        .onAppear {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                AnalyticsManager.logViewProfileEvent()
            }
        }
    }
    
    var cvView: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Section(header: Text("About Me").font(.callout)) {
                        ListCard {
                            Text(profileManager.profile.about.isEmpty ? "A brief profile about me." : userManager.profile.profile.about)
                        }
                    }
                    Section(header: Text("My Skills").font(.callout)) {
                        SkillsView(skillManager: userManager.skills)
//                            .environmentObject(userManager)
                    }
                    Section(header: Text("My Education").font(.callout)) {
                        EducationListView(educationManager: userManager.education)
                            .environmentObject(userManager)
                    }
                    
                    Section(header: Text("My Experience").font(.callout)) {
                        JobsListView(jobsManager: userManager.jobs)
                            .environmentObject(userManager)
                    }
                }
            }
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(profileManager: UserProfileManager(profile: Profile(userID: "", givenName: "John", familyName: "Doe", profilePicture: "", jobTitle: "Software Engineer", about: "")))
                .environmentObject(UserManager())
        }
    }
}
