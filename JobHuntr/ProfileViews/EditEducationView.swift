//
//  EditEducationView.swift
//  JobHuntr
//
//  Created by Adam Ali on 21/03/2023.
//

import SwiftUI
import Amplify

struct EditEducationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userManager: UserManager
    
    
    @State var entryId: String = ""
    @State var companyId: String = ""
    @State var companyName: String = ""
    @State var courseName: String = ""
    @State var start: Date = Date()
    @State var end: Date = Date()
    
    init(education: Education) {
        self.entryId = education.id
        self.companyId = education.companyID
        self.courseName = education.roleName
        self.start = education.startDate.foundationDate
        self.end = education.endDate.foundationDate
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack(alignment: .leading) {
                TextField("Institution", text: $companyName)
                    .textFieldStyle(FormTextFieldStyle())
                    .colorScheme(.dark)
                    .padding()
                
                TextField("Name of Course", text: $courseName)
                    .textFieldStyle(FormTextFieldStyle())
                    .colorScheme(.dark)
                    .padding(.horizontal)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(AppColors.primary)
                        .frame(height: 64)
                    DatePicker("Start Date", selection: $start, displayedComponents: [.date])
                        .padding(.horizontal)
                        .colorScheme(.dark)
                }
                .padding([.top, .horizontal])
                
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
            .padding()
        }
        .onAppear {
            Task {
                if let company = await GlobalDataManager.fetchCompany(id: companyId) {
                    companyName = company.name
                } else {
                    companyName = "Unknown Company"
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    presentationMode.wrappedValue.dismiss()
                }
                .colorScheme(.dark)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    Task {
                        await userManager.saveEducation(id: entryId, companyName: companyName, courseName: courseName, startDate: start, endDate: end)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .colorScheme(.dark)
                .disabled(companyName.isEmpty || courseName.isEmpty)
            }
        }

    }
}

struct EditEducationView_Previews: PreviewProvider {
    static var previews: some View {
        EditEducationView(education: Education(userID: "", companyID: "", startDate: Temporal.Date.now(), endDate: Temporal.Date.now(), roleName: ""))
    }
}
