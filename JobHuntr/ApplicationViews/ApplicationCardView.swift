//
//  ApplicationCardView.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/02/2023.
//

import Amplify
import SwiftUI

struct ApplicationCardView: View {
    /// The application being visualised
    var application: Application
    
    /// The company of the application being visualised.
    @State var company: Company?
    
    init(application: Application) {
        self.application = application
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let company = company {
                    Text(company.name)
                        .font(.headline)
                        .foregroundColor(AppColors.fontColor)
                } else {
                    Text("Unknown Company")
                        .font(.headline)
                        .foregroundColor(AppColors.fontColor)
                }
                Spacer()
                if let dateApplied = application.dateApplied {
                    let dateStr = formatDateString(from: dateApplied.foundationDate)
                    
                    HStack {
                        Text(dateStr)
                            .font(.headline)
                            .foregroundColor(AppColors.fontColor.opacity(0.8))
                    }
                }
            }
            
            Text(application.jobTitle!)
                .font(.subheadline)
                .foregroundColor(AppColors.fontColor)
            
            if let currentStage = application.currentStage {
                CategoryCapsuleView(title: currentStage.name, color: currentStage.color)
            }
        }
        .onAppear {
            Task {
                self.company = await GlobalDataManager.fetchCompany(id: application.companyID!)
            }
        }
        .padding(.bottom)
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
        ZStack {
            AppColors.secondary.ignoresSafeArea()
            ApplicationCardView(application: Application.sampleApplication)
                .environmentObject(SessionManager())
        }
    }
}

extension Application {
    static let sampleApplication: Application = Application(dateApplied: Temporal.Date.now(), currentStage: ApplicationStage.applied, userID: "1", jobTitle: "Tester", companyID: "1")
}
