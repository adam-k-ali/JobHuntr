//
//  NewApplicationView.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/02/2023.
//

import Amplify
import SwiftUI

struct NewApplicationView: View {
    @State private var companyName = ""
    @State private var companyWebsite = ""
    @State private var companyEmail = ""
    @State private var companyPhone = ""
    
    @State private var jobTitle = ""
    @State private var dateApplied = Date()
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack(alignment: .leading) {
                TextField("Company Name", text: $companyName)
                    .textFieldStyle(FormTextFieldStyle())
                    .colorScheme(.dark)
                    .padding()
                
                TextField("Job Title", text: $jobTitle)
                    .textFieldStyle(FormTextFieldStyle())
                    .colorScheme(.dark)
                    .padding()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(AppColors.primary)
                        .frame(height: 64)
                    DatePicker("Date Applied", selection: $dateApplied, displayedComponents: [.date])
                        .padding(.horizontal)
                        .colorScheme(.dark)
                }
                .padding()
                Spacer()
            }
        }
        .navigationTitle("New Application")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    Task {
                        await saveApplication()
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(jobTitle.isEmpty || companyName.isEmpty)
            }
        }
    }
    
    func saveApplication() async {
        // Save the company
        let company = Company(name: companyName, website: companyWebsite, email: companyEmail, phone: companyPhone)
        let companyId = await GlobalDataManager.saveOrFetchCompany(company: company)
        
        let application = Application(dateApplied: Temporal.Date(dateApplied), currentStage: .applied, userID: userManager.getUserId(), jobTitle: jobTitle, companyID: companyId)
        
        await userManager.applications.save(record: application)
    }
}

struct NewApplicationView_Previews: PreviewProvider {
    
    static var previews: some View {
        NewApplicationView()
            .environmentObject(UserManager())
//            .environmentObject(SessionManager())
    }
}
