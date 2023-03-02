//
//  ApplicationCardView.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/02/2023.
//

import Amplify
import SwiftUI

struct ApplicationCardView: View {
    @EnvironmentObject var sessionManager: SessionManager

    @Binding var application: Application
    
    @State private var company: Company?
    
    var body: some View {
        ZStack {
            HStack {
                Circle()
                    .fill(stageColor(application.currentStage ?? .applied))
                    .frame(width: 20, height: 20)
                
                VStack(alignment: .leading) {
                    if let company = company {
                        Text(company.name)
                            .font(.headline)
                    } else {
                        Text("Unknown Company")
                            .font(.headline)
                    }
                    if let jobTitle = application.jobTitle {
                        Text(jobTitle)
                    }Ç
                    
                    if let dateApplied = application.dateApplied {
                        let dateStr = formatDateString(from: dateApplied.foundationDate)
                        
                        Text("Applied \(dateStr)")
                            .font(.subheadline)
                    }
                }
            }
        }
        .onAppear {
            Task {
                if let companyID = application.companyID {
                    company = await sessionManager.fetchCompany(companyID)
                } else {
                    company = Company(name: "Unknown Company", website: "", email: "", phone: "")
                }
            }
        }
    }
    
    func formatDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date)
    }
    
    func stageColor(_ stage: ApplicationStage) -> Color {
        switch stage {
        case .applied:
            return .yellow
        case .preInterview:
            return .blue
        case .interviewing:
            return .blue
        case .offer:
            return .yellow
        case .rejection:
            return .red
        case .accepted:
            return .green
        }
    }
}

struct ApplicationCardView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationCardView(application: .constant(Application.sampleApplication))
    }
}

extension Application {
    static let sampleApplication: Application = Application(dateApplied: Temporal.Date.now(), currentStage: ApplicationStage.applied, userID: "1", jobTitle: "Tester", companyID: "1")
}
