//
//  NewEducationView.swift
//  JobHuntr
//
//  Created by Adam Ali on 17/03/2023.
//

import SwiftUI
import Amplify

struct NewEducationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var educationManager: UserEducationManager
    
    @State var institution: String = ""
    @State var courseName: String = ""
    @State var start: Date = Date()
    @State var end: Date = Date()
    
    var body: some View {
        let bgColor = Color(uiColor: .systemGray6)

        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack(alignment: .leading) {
                TextField("Institution", text: $institution)
                    .textFieldStyle(FormTextFieldStyle())
                    .padding()
                
                TextField("Name of Course", text: $courseName)
                    .textFieldStyle(FormTextFieldStyle())
                    .padding(.horizontal)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(bgColor)
                        .frame(height: 64)
                    
                    DatePicker("Start Date", selection: $start, displayedComponents: [.date])
                        .padding(.horizontal)
                    
                }
                .padding([.top, .horizontal])
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(bgColor)
                        .frame(height: 64)
                    
                    DatePicker("End Date", selection: $end, displayedComponents: [.date])
                        .padding(.horizontal)
                }
                .padding()
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Add Education")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    Task {
                        let companyID = await GlobalDataManager.companyIdFromName(name: institution)
                        let education = Education(userID: userManager.getUserId(), companyID: companyID, startDate: Temporal.Date(start), endDate: Temporal.Date(end), roleName: courseName)
                        await educationManager.save(record: education)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .colorScheme(.dark)
                .disabled(institution.isEmpty || courseName.isEmpty)
            }
        }
    }
}

struct NewEducationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewEducationView(educationManager: UserEducationManager())
                .environmentObject(UserManager())
        }
    }
}
