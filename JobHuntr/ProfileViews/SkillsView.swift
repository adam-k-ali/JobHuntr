//
//  SkillsView.swift
//  JobHuntr
//
//  Created by Adam Ali on 18/03/2023.
//

import SwiftUI

struct SkillsView: View {
    @EnvironmentObject var userManager: UserManager
    @Binding var skills: [String]
    
    @State var showingNewSkill = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(skills, id: \.self) { skill in
                    SkillCardView(content: {
                        Text(skill)
                    }, onDelete: {
                        Task {
                            await userManager.removeUserSkill(skillName: skill)
                        }
                    })
                }
                Button(action: {
                    showingNewSkill = true
                    print("Pressed")
                }, label: {
                    Image(systemName: "plus")
                })
                .buttonStyle(.plain)
            }
            
        }
        .sheet(isPresented: $showingNewSkill) {
            NavigationView {
                NewSkillView()
                    .environmentObject(userManager)
            }
            .colorScheme(.dark)
        }
        
    }
}

struct SkillsView_Previews: PreviewProvider {
    static var previews: some View {
        SkillsView(skills: .constant(["UI Design", "Recruitment", "Testing", "Project Leader"]))
    }
}
