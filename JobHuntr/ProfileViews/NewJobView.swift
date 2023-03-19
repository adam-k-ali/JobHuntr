//
//  NewJobView.swift
//  JobHuntr
//
//  Created by Adam Ali on 18/03/2023.
//

import SwiftUI

struct NewJobView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userManager: UserManager
    
    @State var companyName: String = ""
    @State var jobTitle: String = ""
    @State var jobDescription: String = ""
    @State var start: Date = Date()
    @State var isCurrent: Bool = false
    @State var end: Date = Date()
    
    
    var body: some View {
        Form {
            TextField("Company Name", text: $companyName)
            TextField("Job Title", text: $jobTitle)
            DatePicker("Start Date", selection: $start, displayedComponents: [.date])
            Toggle(isOn: $isCurrent, label: {Text("Current Employment")})
            if !isCurrent {
                DatePicker("End Date", selection: $end, displayedComponents: [.date])
            }
            Text("Description:")
            TextEditor(text: $jobDescription)
            
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    Task {
                        await userManager.saveJob(companyName: companyName, jobTitle: jobTitle, description: jobDescription, startDate: start, endDate: isCurrent ? nil : end)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(companyName.isEmpty || jobTitle.isEmpty)
            }
        }
    }
}

//struct NewJobView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewJobView()
//    }
//}
