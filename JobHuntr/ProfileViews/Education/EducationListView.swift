//
//  EducationListView.swift
//  JobHuntr
//
//  Created by Adam Ali on 03/04/2023.
//

import SwiftUI

struct EducationListView: View {
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var educationManager: UserEducationManager
    
    @State var showNewEducation: Bool = false
    
    var body: some View {
        Group {
            if educationManager.records.isEmpty {
                ListCard {
                    Text("No Education History")
                }
            }
            // List of education history
            ForEach($educationManager.records) { $education in
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
                    showNewEducation = true
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
        .sheet(isPresented: $showNewEducation) {
            NavigationView {
                NewEducationView(educationManager: educationManager)
                    .environmentObject(userManager)
            }
        }
    }
    
    func deleteEducation(education: Education) {
        Task {
            await educationManager.delete(record: education)
        }
    }
    
}

struct EducationListView_Previews: PreviewProvider {
    static var previews: some View {
        EducationListView(educationManager: UserEducationManager())
            .environmentObject(UserManager())
    }
}
