//
//  NewSkillView.swift
//  JobHuntr
//
//  Created by Adam Ali on 18/03/2023.
//

import SwiftUI

struct NewSkillView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userManager: UserManager
    
    @State var skillName: String = ""
    
    var body: some View {
        Form {
            TextField("Skill", text: $skillName)
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    Task {
                        await userManager.addUserSkill(skillName: self.skillName)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(skillName.isEmpty)
            }
        }
    }
}

//struct NewSkillView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewSkillView()
//    }
//}
