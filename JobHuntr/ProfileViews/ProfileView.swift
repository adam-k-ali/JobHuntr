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
    
    @State var activeSheet: ProfileAction?
    @State var selectedEducation: Education?
    
    @State var name: String = ""

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack {
                HStack {
                    HStack {
                        ProfileHeader(name: name)
                            .environmentObject(userManager)
                        Spacer()
                    }
                    
                    Spacer()
                    Button(action: {
                        activeSheet = .editProfile
                    }, label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: 20, height: 20)
                    })
                    .buttonStyle(.plain)
                }
                .padding(24)
                
                // Subtitle: Current Job Title
                if !userManager.profile.profile.jobTitle.isEmpty {
                    HStack {
                        Text(userManager.profile.profile.jobTitle)
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
        .sheet(item: $activeSheet) { sheet in
            NavigationView {
                switch sheet {
                case .newEducation:
                    NewEducationView()
                        .environmentObject(userManager)
                case .newJob:
                    NewJobView()
                        .environmentObject(userManager)
                case .editProfile:
                    EditProfileView()
                        .environmentObject(userManager)
                }
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
                            Text(userManager.profile.profile.about.isEmpty ? "A brief profile about me." : userManager.profile.profile.about)
                        }
                    }
                    Section(header: Text("My Skills").font(.callout)) {
                        SkillsView(skills: $userManager.skills.records)
                            .environmentObject(userManager)
                    }
                    Section(header: Text("My Education").font(.callout)) {
                        educationList
                    }
                    
                    Section(header: Text("My Experience").font(.callout)) {
                        jobsList
                    }
                }
            }
        }
    }
    
    var educationList: some View {
        Group {
            if (userManager.education.records.isEmpty) {
                ListCard {
                    Text("No Education History")
                }
            }
            // List of education history
            ForEach($userManager.education.records) { $education in
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
                    activeSheet = .newEducation
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
    }
    
    var jobsList: some View {
        Group {
            if userManager.jobs.records.isEmpty {
                ListCard {
                    Text("No Experience")
                }
            }
            // Work experience list
            ForEach($userManager.jobs.records) { $job in
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
                    activeSheet = .newJob
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
    
    func reload() {
        if userManager.profile.profile.givenName.isEmpty {
            self.name = userManager.getUsername()
        } else {
            self.name = userManager.profile.profile.givenName
        }
    }
    
    func deleteEducation(education: Education) {
        Task {
            await userManager.education.delete(record: education)
        }
    }
    
    func deleteJob(job: Job) {
        Task {
            await userManager.jobs.delete(record: job)
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
