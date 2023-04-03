//
//  JobsListView.swift
//  JobHuntr
//
//  Created by Adam Ali on 03/04/2023.
//

import SwiftUI

struct JobsListView: View {
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var jobsManager: UserJobManager
    
    @State var showNewJob = false
    
    var body: some View {
        Group {
            if jobsManager.records.isEmpty {
                ListCard {
                    Text("No Experience")
                }
            }
            // Work experience list
            ForEach($jobsManager.records) { $job in
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
                    showNewJob = true
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
        .sheet(isPresented: $showNewJob) {
            NavigationView {
                NewJobView(jobsManager: jobsManager)
                    .environmentObject(userManager)
            }
        }
    }
    
    func deleteJob(job: Job) {
        Task {
            await jobsManager.delete(record: job)
        }
    }
}

struct JobsListView_Previews: PreviewProvider {
    static var previews: some View {
        JobsListView(jobsManager: UserJobManager())
            .environmentObject(UserManager())
    }
}
