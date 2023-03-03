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
                    if let company = company {
                        Text(company.name)
                            .font(.headline)
                    } else {
                        Text("Unknown Company")
                            .font(.headline)
                    }
                    if let jobTitle = application.jobTitle {
                        Text(jobTitle)
                    }
                    
                    if let dateApplied = application.dateApplied {
                        let dateStr = formatDateString(from: dateApplied.foundationDate)
                        
                        HStack {
                            Image(systemName: "calendar")
                            Text("Applied \(dateStr)")
                                .font(.subheadline)
                        }
                    }
                    ZStack {
                        Capsule()
                            .fill(Color(uiColor: .systemGray))
                            .frame(width: 128, height: 32)
                        Text(application.currentStage!.name)
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
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            return (red, green, blue, alpha)
        }
}

extension Color {
    init(uiColor: UIColor) {
            self.init(red: Double(uiColor.rgba.red),
                      green: Double(uiColor.rgba.green),
                      blue: Double(uiColor.rgba.blue),
                      opacity: Double(uiColor.rgba.alpha))
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
