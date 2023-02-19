//
//  ApplicationDetailView.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/02/2023.
//

import SwiftUI

struct ApplicationDetailView: View {
    @EnvironmentObject var sessionManager: SessionManager

    @Binding var application: Application
    
    @State private var showUpdateView = false
    @State private var company: Company?
    
    var body: some View {
        VStack(alignment: .leading) {
            // Company Card View
            if let companyUnwrapped = company {
                CompanyCardView(company: companyUnwrapped)
            }
            VStack {
                // Progression View
                ProgressionView(applicationStage: $application.currentStage)
                Divider()
                Button(action: {
                    showUpdateView = true
                }) {
                    Text("Update")
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle(application.jobTitle)
        .onAppear {
            Task {
                await refresh()
            }
        }
        
        .sheet(isPresented: $showUpdateView, onDismiss: {
            Task {
                await refresh()
            }
        }) {
            NavigationView {
                UpdateApplicationView(application: application)
            }
        }
        
    }
    
    func refresh() async {
        company = await sessionManager.fetchCompany(application.companyID)
        application = await sessionManager.fetchApplication(id: application.id)!
    }
}

struct ApplicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ApplicationDetailView(application: .constant(Application.sampleApplication))
        }
    }
}
