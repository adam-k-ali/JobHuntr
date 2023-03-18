//
//  ProjectCard.swift
//  JobHuntr
//
//  Created by Adam Ali on 17/03/2023.
//

import SwiftUI

struct ProjectCard: View {
    var projectName: String
    var projectDescription: String
    var projectGrade: String?
    
    var body: some View {
        HStack {
//            Image(systemName: "chevron.right.square")
            VStack(alignment: .leading) {
                Text(projectName)
                    .font(.headline)
                Text(projectDescription)
            }
            .padding()
        }
    }
}

struct ProjectCard_Previews: PreviewProvider {
    static var previews: some View {
        ProjectCard(projectName: "Image Re-Composition using Computer Vision", projectDescription: "Researched and Implemented Machine-Learning Algorithms to build a tool that automatically crops images.")
    }
}
