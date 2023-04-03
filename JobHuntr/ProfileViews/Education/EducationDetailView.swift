//
//  EducationDetailView.swift
//  JobHuntr
//
//  Created by Adam Ali on 28/03/2023.
//

import Amplify
import SwiftUI

struct EducationDetailView: View {
    @EnvironmentObject var userManager: UserManager
    
    var education: Education
    @State var courses: [Course] = []
    @State var companyName: String = ""
    
    @State var showingNewCourse: Bool = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack(alignment: .leading) {
                Text(education.roleName)
                    .font(.headline)
                    .padding(.leading, 4)
                
                // Course List
                ScrollView {
                    ForEach(courses, id: \.id) { course in
                        ListCard(isChangeable: true, onDelete: {
                            deleteCourse(course: course)
                        }) {
                            CourseCard(course: course)
                        }
                    }
                    
                    // New Button
                    ListCard {
                        Button(action: {
                            showingNewCourse = true
                        }) {
                            HStack {
                                Spacer()
                                Text("Add Course")
                                Spacer()
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Spacer()
            }
            
            .padding()
        }
        .navigationTitle(companyName)
        .onAppear {
            self.reload()
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                Task {
                    if let company = await GlobalDataManager.fetchCompany(id: education.companyID) {
                        companyName = company.name
                    } else {
                        companyName = "Unknown Company"
                    }
                }
            } else {
                companyName = "Unknown Company"
            }
        }
        .sheet(isPresented: $showingNewCourse) {
            NavigationView {
                NewCourseView(educationId: education.id)
            }
            .onDisappear {
                self.reload()
            }
        }
    }
    
    func deleteCourse(course: Course) {
        Task {
            await userManager.courses.delete(record: course)
        }
        self.reload()
    }
    
    func reload() {
        self.courses = userManager.courses.lazyCoursesForEducation(educationId: education.id)
    }
}

struct EducationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EducationDetailView(education: Education(userID: "", companyID: "", startDate: Temporal.Date.now(), endDate: Temporal.Date.now(), roleName: "MEng Computer Science"))
            .environmentObject(UserManager())
        }
    }
}
