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
                let stage = Binding<ApplicationStage> (
                    get: {
                        return application.currentStage!
                    },
                    set: {
                        application.currentStage = $0
                    }
                )
                let dateStr = formatDateString(from: application.dateApplied!.foundationDate)
                Text("Applied on \(dateStr)")
                ProgressionView(applicationStage: stage)
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
        .navigationTitle(application.jobTitle ?? "Unknown Job")
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
                UpdateApplicationView(application: $application)
            }
        }
        
    }
    
    func formatDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date)
    }
    
    func refresh() async {
        if let companyID = application.companyID {
            company = await sessionManager.fetchCompany(companyID)
        }
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
