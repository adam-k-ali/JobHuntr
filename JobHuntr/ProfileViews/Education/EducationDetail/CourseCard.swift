//
//  CourseCard.swift
//  JobHuntr
//
//  Created by Adam Ali on 28/03/2023.
//

import SwiftUI

struct CourseCard: View {
    @State var course: Course
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(course.name)
                .font(.headline)
            Text("Grade: \(course.grade)")
                .font(.caption)
            Text(course.description)
                .font(.subheadline)
            
        }
        .padding()
    }
}

struct CourseCard_Previews: PreviewProvider {
    static var previews: some View {
        CourseCard(course: Course(educationID: "", name: "Course Name", description: "Description", grade: "First"))
    }
}
