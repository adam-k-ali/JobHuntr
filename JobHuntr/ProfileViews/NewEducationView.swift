//
//  NewEducationView.swift
//  JobHuntr
//
//  Created by Adam Ali on 17/03/2023.
//

import SwiftUI

struct NewEducationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userManager: UserManager
    
    @State var institution: String = ""
    @State var courseName: String = ""
    @State var start: Date = Date()
    @State var end: Date = Date()
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack(alignment: .leading) {
                TextField("Institution", text: $institution)
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
                        await userManager.saveEducation(companyName: institution, courseName: courseName, startDate: start, endDate: end)
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
            NewEducationView()
                .environmentObject(UserManager(username: "", userId: ""))
        }
    }
}
