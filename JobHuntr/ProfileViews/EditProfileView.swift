//
//  EditProfileView.swift
//  JobHuntr
//
//  Created by Adam Ali on 18/03/2023.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        Form {
            HStack {
                EditableImage(width: 96.0, height: 96.0)
                
                VStack {
                    TextField("Given Name", text: $userManager.profile.givenName)
                    Spacer()
                    TextField("Family Name", text: $userManager.profile.familyName)
                }
                .padding()
                
            }
            
            TextField("Current Job Title", text: $userManager.profile.jobTitle)
            
            Section(header: Text("About Me")) {
                TextEditor(text: $userManager.profile.about)
            }
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
                        await userManager.saveUserProfile()
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
