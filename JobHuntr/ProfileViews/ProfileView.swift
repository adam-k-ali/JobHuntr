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
    
    var body: some View {
        VStack() {
            ProfileCardView()
            Divider()
        }
        List {
//            Section(header: Text("Skills")) {
//                SkillsView()
//            }
//            .listRowBackground(Color.clear)
//            .listRowInsets(.init())
            
            Section {
                Text(userManager.profile.about)
            } header: {
                Text("About Me")
            }
            
            Section {
                ForEach($userManager.education) { $education in
                    let startDate = education.startDate.foundationDate.format(formatString: "MMM yyyy")
                    let endDate = education.endDate.foundationDate.format(formatString: "MMM yyyy")
                    InstitutionCard(type: .education,
                                    companyID: education.companyID,
                                    title: education.roleName,
                                    subheading: "\(startDate) - \(endDate)"
                    )
                }
                Button(action: {
                    showingNewEducation = true
                }) {
                    HStack {
                        Spacer()
                        Text("Add Education")
                        Spacer()
                    }
                }
            } header: {
                Text("Education")
            }
            Section {
                ForEach($userManager.jobs) { $job in
                    let startDate = job.startDate.foundationDate.format(formatString: "MMM yyyy")
                    if job.endDate != nil {
                        let endDate = job.endDate!.foundationDate.format(formatString: "MMM yyyy")
                        InstitutionCard(type: .placeOfWork,
                                        companyID: job.companyID,
                                        title: job.jobTitle,
                                        subheading: "\(startDate) - \(endDate)")
                    } else {
                        InstitutionCard(type: .placeOfWork,
                                        companyID: job.companyID,
                                        title: job.jobTitle,
                                        subheading: "\(startDate) - Present")
                    }
                    
                }
                Button(action: {
                    showingNewJob = true
                }) {
                    HStack {
                        Spacer()
                        Text("Add Experience")
                        Spacer()
                    }
                }
            } header: {
                Text("Experience")
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    showingEditProfile = true
                }, label: {
                    Image(systemName: "pencil.circle")
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
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
                .environmentObject(UserManager(user: DummyUser()))
        }
    }
}
