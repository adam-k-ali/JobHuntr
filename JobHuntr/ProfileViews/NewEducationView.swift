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
        Form {
            TextField("Institution", text: $institution)
            TextField("Name of Course", text: $courseName)
            DatePicker("Start Date", selection: $start, displayedComponents: [.date])
            DatePicker("End Date", selection: $end, displayedComponents: [.date])
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
                        await userManager.saveEducation(companyName: institution, courseName: courseName, startDate: start, endDate: end)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(institution.isEmpty || courseName.isEmpty)
            }
        }
    }
}

//struct NewEducationView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewEducationView()
//    }
//}
