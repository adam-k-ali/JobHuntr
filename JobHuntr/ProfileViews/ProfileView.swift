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
    
    @Binding var name: String

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack {
                HStack {
                    HStack {
                        Label(title: {
                            if !name.isEmpty {
                                Text("**Welcome, \(name)!**")
                                    .font(.largeTitle)
                            } else {
                                Text("**Welcome, \(userManager.getUsername())**")
                                    .font(.largeTitle)
                            }
                        }, icon: {
                            ProfilePicture(showEdit: false, size: CGSize(width: 42, height: 42))
                                .environmentObject(userManager)
                        })
                        Spacer()
                    }
                    
                    Spacer()
                    Button(action: {
                        showingEditProfile = true
                    }, label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: 20, height: 20)
                    })
                    .buttonStyle(.plain)
//                    .padding(.top, 50)
                }
                .padding(24)
                
                if !userManager.profile.jobTitle.isEmpty {
                    HStack {
                        Text(userManager.profile.jobTitle)
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.leading, 20)
                }
                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Section(header: Text("About Me").font(.callout)) {
                                ListCard {
                                    Text(userManager.profile.about.isEmpty ? "A brief profile about me." : userManager.profile.about)
                                }
                            }
                            Section(header: Text("My Skills").font(.callout)) {
                                SkillsView(skills: $userManager.skills)
                                    .environmentObject(userManager)
                            }
                            Section(header: Text("My Education").font(.callout)) {
                                
                                if (userManager.education.isEmpty) {
                                    ListCard {
                                        Text("No Education History")
                                    }
                                }
                                // List of education history
                                ForEach($userManager.education) { $education in
                                    let startDate = education.startDate.foundationDate.format(formatString: "MMM yyyy")
                                    let endDate = education.endDate.foundationDate.format(formatString: "MMM yyyy")
                                    NavigationLink(destination: {
                                        NavigationView {
                                            EducationDetailView(education: education)
                                        }
                                    }) {
                                        ListCard(isChangeable: true, onDelete: {
                                            deleteEducation(education: education)
                                        }) {
                                            InstitutionCard(type: .education,
                                                            companyID: education.companyID,
                                                            title: education.roleName,
                                                            subheading: "\(startDate) - \(endDate)",
                                                            isLink: true
                                            )
                                        }
                                    }
                                    .buttonStyle(.plain)
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
                            
                            Section(header: Text("My Experience").font(.callout)) {
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
        .onAppear {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                AnalyticsManager.logViewProfileEvent()
            }
        }
        .sheet(isPresented: $showingNewEducation) {
            NavigationView {
                NewEducationView()
                    .environmentObject(userManager)
            }
        }
        .sheet(isPresented: $showingNewJob) {
            NavigationView {
                NewJobView()
                    .environmentObject(userManager)
            }
        }
        .sheet(isPresented: $showingEditProfile) {
            NavigationView {
                EditProfileView()
                    .environmentObject(userManager)
            }
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
            ProfileView(name: .constant("Adam"))
                .environmentObject(UserManager())
        }
    }
}
