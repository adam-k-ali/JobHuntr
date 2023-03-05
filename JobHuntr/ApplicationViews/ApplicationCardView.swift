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
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        if let company = company {
                            Text(company.name)
                                .font(.headline)
                        } else {
                            Text("Unknown Company")
                                .font(.headline)
                        }
                        Spacer()
                        if let dateApplied = application.dateApplied {
                            let dateStr = formatDateString(from: dateApplied.foundationDate)
                            
                            HStack {
                                Text(dateStr)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    if let jobTitle = application.jobTitle {
                        Text(jobTitle)
                    }
                    
                    
                    HStack {
                        ZStack {
                            Capsule()
                                .fill(application.currentStage!.color)
//                                .fill(Color(uiColor: .systemGray))
                                .frame(width: 128, height: 32)
                            Text(application.currentStage!.name)
                        }
                        
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
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date)
    }
}

struct ApplicationCardView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationCardView(application: .constant(Application.sampleApplication))
            .environmentObject(SessionManager())
    }
}

extension Application {
    static let sampleApplication: Application = Application(dateApplied: Temporal.Date.now(), currentStage: ApplicationStage.applied, userID: "1", jobTitle: "Tester", companyID: "1")
}
