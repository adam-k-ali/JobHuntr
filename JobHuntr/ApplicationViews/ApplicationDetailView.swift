//
//  ApplicationDetailView.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/02/2023.
//

import SwiftUI

struct ApplicationDetailView: View {
    @EnvironmentObject var userManager: UserManager

    @Binding var application: Application
    
    @State private var showUpdateView = false
    @State private var company: Company?
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack(alignment: .leading) {
                // Company Card View
                if let companyUnwrapped = company {
                    CompanyCardView(company: companyUnwrapped)
                }
                VStack {
                    // Progression View
                    let dateStr = application.dateApplied!.foundationDate.format(date: .short, time: .none)
                    
                        Text("Applied on \(dateStr)")
                            .foregroundColor(AppColors.fontColor)
                    ProgressionView(applicationStage: application.currentStage!)
                        .colorScheme(.dark)
                    
                    Spacer()
                    Button(action: {
                        showUpdateView = true
                    }) {
                        Text("Update")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .colorScheme(.dark)
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle(application.jobTitle ?? "Unknown Job")
        .sheet(isPresented: $showUpdateView) {
            NavigationView {
                UpdateApplicationView(application: $application)
                    .environmentObject(userManager)
            }
        }
        
    }
    
}

struct ApplicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ApplicationDetailView(application: .constant(Application.sampleApplication))
                .environmentObject(UserManager(username: "", userId: ""))
        }
    }
}
