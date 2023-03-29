//
//  NewCourseView.swift
//  JobHuntr
//
//  Created by Adam Ali on 28/03/2023.
//

import SwiftUI

struct NewCourseView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userManager: UserManager
    
    var educationId: String
    @State var courseName: String = ""
    @State var grade: String = ""
    @State var description: String = ""
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack(alignment: .leading) {
                TextField("Course Name", text: $courseName)
                    .textFieldStyle(FormTextFieldStyle())
                TextField("Grade Achieved", text: $grade)
                    .textFieldStyle(FormTextFieldStyle())
                
                TextEditView(placeholder: "Description", text: $description)
                    .background(Color.blue)
                    .frame(minHeight: 32, maxHeight: 128)
                    .cornerRadius(8)
                
                HStack {
                    Spacer()
                    if description.count > 128 {
                        Text("Characters: \(description.count)/128")
                            .foregroundColor(.red)
                            .font(.caption)
                    } else {
                        Text("Characters: \(description.count)/128")
                            .font(.caption)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("New Course")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    let course = Course(educationID: educationId, name: courseName, description: description, grade: grade)
                    Task {
                        await userManager.saveCourse(course: course)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(courseName.isEmpty)
            }
        }
    }
}

struct NewCourseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewCourseView(educationId: "")
                .environmentObject(UserManager())
        }
    }
}
