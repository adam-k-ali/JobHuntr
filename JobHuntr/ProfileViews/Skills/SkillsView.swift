//
//  SkillsView.swift
//  JobHuntr
//
//  Created by Adam Ali on 18/03/2023.
//

import SwiftUI

struct SkillsView: View {
//    @EnvironmentObject var userManager: UserManager
    
    @ObservedObject var skillManager: UserSkillsManager
    
    @State var showingNewSkill = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(skillManager.records, id: \.self) { skill in
                    SkillCardView(content: {
                        Text(skill)
                    }, onDelete: {
                        Task {
                            await skillManager.delete(record: skill)
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
                NewSkillView(skillManager: skillManager)
//                    .environmentObject(userManager)
            }
        }
        
    }
}

struct SkillsView_Previews: PreviewProvider {
    static var previews: some View {
        SkillsView(skillManager: UserSkillsManager())
//            .environmentObject(UserManager())
    }
}
