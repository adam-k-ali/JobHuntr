//
//  ProfileView.swift
//  JobHuntr
//
//  Created by Adam Ali on 17/03/2023.
//

import SwiftUI
import Amplify

struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    
    @State var showingNewEducation: Bool = false
    @State var showingNewJob: Bool = false
    @State var showingEditProfile: Bool = false
    
    @State var showingEditEducation: Bool = false
    @State var selectedEducation: Education?
    
    @State var name: String = ""

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack {
                if !userManager.profile.jobTitle.isEmpty {
                    HStack {
                        Text(userManager.profile.jobTitle)
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.leading, 20)
                }
                VStack {
                    VStack(spacing: 32) {
                        ProfilePicture()
                            .environmentObject(userManager)
                            .frame(width: 200, height: 200)
                            .shadow(radius: 12)
                        Divider()
                    }
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Section(header: Text("Skills").font(.callout)) {
                                SkillsView(skills: $userManager.skills)
                                    .environmentObject(userManager)
                            }
                            Section(header: Text("About Me").font(.callout)) {
                                ListCard {
                                    Text(userManager.profile.about.isEmpty ? "A brief profile about me." : userManager.profile.about)
                                }
                            }
                            Section(header: Text("Education").font(.callout)) {
                                
                                if (userManager.education.isEmpty) {
                                    ListCard {
                                        Text("No Education History")
                                    }
                                }
                                // List of education history
                                ForEach($userManager.education) { $education in
                                    let startDate = education.startDate.foundationDate.format(formatString: "MMM yyyy")
                                    let endDate = education.endDate.foundationDate.format(formatString: "MMM yyyy")
                                    
                                    ListCard(isChangeable: true, onDelete: {
                                        deleteEducation(education: education)
                                    }) {
                                        InstitutionCard(type: .education,
                                                        companyID: education.companyID,
                                                        title: education.roleName,
                                                        subheading: "\(startDate) - \(endDate)"
                                        )
                                    }
                                }
                                // New Education card
                                ListCard {
                                    Button(action: {
                                        showingNewEducation = true
                                    }) {
                                        HStack {
                                            Spacer()
                                            Text("Add Education")
                                            Spacer()
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                                
                            }
                            
                            Section(header: Text("Experience").font(.callout)) {
                                if userManager.jobs.isEmpty {
                                    ListCard {
                                        Text("No Experience")
                                    }
                                }
                                // Work experience list
                                ForEach($userManager.jobs) { $job in
                                    let startDate = job.startDate.foundationDate.format(formatString: "MMM yyyy")
                                    if job.endDate != nil {
                                        let endDate = job.endDate!.foundationDate.format(formatString: "MMM yyyy")
                                        ListCard(isChangeable: true, onDelete: {
                                            deleteJob(job: job)
                                        }) {
                                            InstitutionCard(type: .placeOfWork,
                                                            companyID: job.companyID,
                                                            title: job.jobTitle,
                                                            subheading: "\(startDate) - \(endDate)")
                                        }
                                    } else {
                                        ListCard(isChangeable: true, onDelete: {
                                            deleteJob(job: job)
                                        }) {
                                            InstitutionCard(type: .placeOfWork,
                                                            companyID: job.companyID,
                                                            title: job.jobTitle,
                                                            subheading: "\(startDate) - Present")
                                        }
                                    }
                                }
                                
                                // New Experience Button
                                ListCard {
                                    Button(action: {
                                        showingNewJob = true
                                    }) {
                                        HStack {
                                            Spacer()
                                            Text("Add Experience")
                                            Spacer()
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }

                            }
                        }
                    }
                }
                .padding()
            }
            
        }
        .navigationTitle("Welcome, \(self.name)!")
        .onAppear {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                AnalyticsManager.logViewProfileEvent()
            }
            if self.userManager.profile.givenName.isEmpty {
                self.name = userManager.getUsername()
            } else {
                self.name = userManager.profile.givenName
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    showingEditProfile = true
                }, label: {
                    Image(systemName: "pencil")
                })
            }

        }
        .sheet(isPresented: $showingNewEducation) {
            NavigationView {
                NewEducationView()
                    .environmentObject(userManager)
            }
            .colorScheme(.dark)
        }
        .sheet(isPresented: $showingNewJob) {
            NavigationView {
                NewJobView()
                    .environmentObject(userManager)
            }
            .colorScheme(.dark)
        }
        .sheet(isPresented: $showingEditProfile) {
            NavigationView {
                EditProfileView()
                    .environmentObject(userManager)
            }
            .colorScheme(.dark)
        }
        .sheet(isPresented: $showingEditEducation) {
            if let education = self.selectedEducation {
                NavigationView {
                    EditEducationView(education: education)
                        .environmentObject(userManager)
                }
            } else {
                Text("Error")
            }
        }
    }
    
    func deleteEducation(education: Education) {
        Task {
            await userManager.deleteEducation(education: education)
        }
    }
    
    func deleteJob(job: Job) {
        Task {
            await userManager.deleteJob(job: job)
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
                .environmentObject(UserManager())
        }
    }
}
