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
    
    var body: some View {
        ZStack(alignment: .top) {
            AppColors.primary.ignoresSafeArea()
            ScrollView {
                VStack (alignment: .leading, spacing: 16) {
                    Section(
                        header: Text("Skills")
                            .font(.callout)
                            .foregroundColor(AppColors.fontColor)
                    ) {
                        SkillsView(skills: $userManager.skills)
                            .environmentObject(userManager)
                            .padding(.horizontal)
                    }
                    
                    Section(
                        header: Text("About Me")
                            .font(.callout)
                            .foregroundColor(AppColors.fontColor)
                    ) {
                        ListCard {
                            Text(userManager.profile.about)
                                .foregroundColor(AppColors.fontColor)
                                .padding()
                        }
                    }
                    
                    Section (
                        header: Text("Education")
                            .font(.callout)
                            .foregroundColor(AppColors.fontColor)
                    ) {
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
                                .colorScheme(.dark)
                            }
                            
                        }
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
                            .foregroundColor(AppColors.fontColor)
                        }
                    }
                    
                    Section(
                        header: Text("Experience")
                            .font(.callout)
                            .foregroundColor(AppColors.fontColor)
                    ) {
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
                                    .colorScheme(.dark)
                                }
                            } else {
                                ListCard(isChangeable: true, onDelete: {
                                    deleteJob(job: job)
                                }) {
                                    InstitutionCard(type: .placeOfWork,
                                                    companyID: job.companyID,
                                                    title: job.jobTitle,
                                                    subheading: "\(startDate) - Present")
                                    .colorScheme(.dark)
                                }
                            }
                            
                        }
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
                            .foregroundColor(AppColors.fontColor)
                        }
                    }
                    
                }
            }
            
            .padding()
            .background(AppColors.primary.ignoresSafeArea())
            .padding(.top, 256)
            
            ProfileCardView()
                .shadow(radius: 2)
                .frame(height: 256)
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
            ProfileView()
                .environmentObject(UserManager(username: "Dummy", userId: ""))
        }
    }
}
