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
    
    @State var name: String = ""
    
    @ObservedObject var profileManager: UserProfileManager

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack {
                HStack {
                    HStack {
                        ProfileHeader(profileManager: profileManager, name: name)
                            .environmentObject(userManager)
                        Spacer()
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
                .padding(24)
                
                // Subtitle: Current Job Title
                if !profileManager.profile.jobTitle.isEmpty {
                    HStack {
                        Text(profileManager.profile.jobTitle)
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.leading, 20)
                }
                
                cvView
                    .padding()
            }
            
        }
        .onAppear {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                AnalyticsManager.logViewProfileEvent()
            }
            reload()
        }
        .sheet(isPresented: $showingEditView) {
            NavigationView {
                EditProfileView(profileManager: profileManager)
                //                .environmentObject(userManager)
            }
            .onDisappear {
                reload()
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
    
    func reload() {
        if profileManager.profile.givenName.isEmpty {
            self.name = userManager.getUsername()
        } else {
            self.name = profileManager.profile.givenName
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(profileManager: UserProfileManager())
                .environmentObject(UserManager())
        }
    }
}
