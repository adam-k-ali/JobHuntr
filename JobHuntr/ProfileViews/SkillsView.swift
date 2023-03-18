//
//  SkillsView.swift
//  JobHuntr
//
//  Created by Adam Ali on 18/03/2023.
//

import SwiftUI

struct SkillsView: View {
    var skills: [String] = ["Test", "Skill", "Another Skill", "AAA"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(skills, id: \.self) { skill in
                    SkillCardView(content: {Text(skill)})
                }
                SkillCardView(content: {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "plus")
                    })
                    .buttonStyle(.plain)
                })
            }
        }
    }
}

struct SkillsView_Previews: PreviewProvider {
    static var previews: some View {
        SkillsView()
    }
}
