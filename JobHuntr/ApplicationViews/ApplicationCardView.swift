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
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(self.application.currentStage?.color)
            HStack(alignment: .top) {
                let companyName = company != nil ? company!.name : "Unknown Company"
                VStack(alignment: .leading, spacing: 16) {
                    Text(companyName)
                        .font(.headline)
                    Text(self.application.jobTitle!)
                }
                Spacer()
                
                CategoryCapsuleView(title: application.currentStage!.name, color: .white.opacity(0.40))
            }
            .padding()
            
        }
        .onAppear {
            Task {
                self.company = await GlobalDataManager.fetchCompany(id: application.companyID!)
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
        ZStack {
            AppColors.secondary.ignoresSafeArea()
            ApplicationCardView(application: Application.sampleApplication)
        }
    }
}

extension Application {
    static let sampleApplication: Application = Application(dateApplied: Temporal.Date.now(), currentStage: ApplicationStage.applied, userID: "1", jobTitle: "Tester", companyID: "1")
}
