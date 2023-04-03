//
//  NewSkillView.swift
//  JobHuntr
//
//  Created by Adam Ali on 18/03/2023.
//

import SwiftUI

struct NewSkillView: View {
    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var userManager: UserManager
    
    @ObservedObject var skillManager: UserSkillsManager
    
    @State var skillName: String = ""
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack {
                TextField("Skill", text: $skillName)
                    .textFieldStyle(FormTextFieldStyle())
                Spacer()
            }
            .padding()
        }
        .navigationTitle("New Skill")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    Task {
                        await skillManager.save(record: self.skillName)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(skillName.isEmpty)
            }
        }
    }
}

struct NewSkillView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewSkillView(skillManager: UserSkillsManager())
//                .environmentObject(UserManager())
        }
    }
}
