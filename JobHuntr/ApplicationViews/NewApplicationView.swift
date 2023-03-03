//
//  NewApplicationView.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/02/2023.
//

import Amplify
import SwiftUI

struct NewApplicationView: View {
    let user: AuthUser
    
    @State private var companyName = ""
    @State private var companyWebsite = ""
    @State private var companyEmail = ""
    @State private var companyPhone = ""
    
    @State private var jobTitle = ""
    @State private var dateApplied = Date()
    
    @State private var error = ""
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        NavigationView {
            VStack {
                Text(error)
                    .font(.headline)
                    .foregroundColor(.red)
                Form {
                    Section(header: Text("Company Information")) {
                        TextField("Company Name", text: $companyName)
                    }
                    
                    Section(header: Text("Application")) {
                        TextField("Job Title", text: $jobTitle)
                        DatePicker("Date Applied", selection: $dateApplied, displayedComponents: [.date])
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    if jobTitle.isEmpty {
                        error = "Enter a job title"
                        return
                    }
                    if companyName.isEmpty {
                        error = "Enter a company name"
                        return
                    }
                    Task {
                        await saveApplication()
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    func saveApplication() async {
        do {
            var companyID = ""
            if let company = await sessionManager.findCompanyByName(companyName) {
                companyID = company.id
            } else {
                // Save new company
                let company = Company(name: companyName, website: companyWebsite, email: companyEmail, phone: companyPhone)
                companyID = company.id
                try await Amplify.DataStore.save(company)
            }
            
            // Save application
            let application = Application(dateApplied: Temporal.Date(dateApplied), currentStage: .applied, userID: user.userId, jobTitle: jobTitle, companyID: companyID)
            try await Amplify.DataStore.save(application)
        } catch let error as DataStoreError {
            print("Unable to save company and application \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
    }
}

struct NewApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        NewApplicationView(user: DummyUser())
    }
}
