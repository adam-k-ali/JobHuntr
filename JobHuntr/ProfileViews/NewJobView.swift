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
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack {
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
                    DatePicker("Start Date", selection: $start, displayedComponents: [.date])
                        .padding(.horizontal)
                        .colorScheme(.dark)
                }
                .padding()
                
                Toggle(isOn: $isCurrent, label: {Text("Current Employment")})
                    .padding()
                
                if !isCurrent {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(AppColors.primary)
                            .frame(height: 64)
                        DatePicker("End Date", selection: $end, displayedComponents: [.date])
                            .padding(.horizontal)
                            .colorScheme(.dark)
                    }
                    .padding()
                }
                
                
                ZStack(alignment: .topLeading) {
//                    RoundedRectangle(cornerRadius: 8)
//                        .foregroundColor(AppColors.primary)
                    
                    TextEditor(text: $jobDescription)
                        .cornerRadius(8.0)
                        .colorMultiply(AppColors.primary)
                        
                    
                    if jobDescription.isEmpty {
                        Text("Description")
                            .foregroundColor(.white.opacity(0.5))
                            .padding(6)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Add Experience")
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
