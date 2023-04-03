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
    
    @State var givenName: String = ""
    @State var familyName: String = ""
    @State var jobTitle: String = ""
    @State var about: String = ""
    
    var body: some View {
        Form {
            HStack {
                EditableImage(width: 96.0, height: 96.0)
                
                VStack {
                    TextField("Given Name", text: $givenName)
                    Spacer()
                    TextField("Family Name", text: $familyName)
                }
                .padding()
                
            }
            
            TextField("Current Job Title", text: $jobTitle)
            
            Section {
                TextEditor(text: $about)
                    .frame(minHeight: 256)
            } header: {
                Text("About Me")
            } footer: {
                if about.count > 512 {
                    Text("Characters: \(about.count)/512")
                        .foregroundColor(.red)
                } else {
                    Text("Characters: \(about.count)/512")
                }
                
            }
            
        }
        .onAppear {
            self.givenName = userManager.profile.profile.givenName
            self.familyName = userManager.profile.profile.familyName
            self.jobTitle = userManager.profile.profile.jobTitle
            self.about = userManager.profile.profile.about
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    // Update local storage
                    userManager.profile.profile.givenName = givenName
                    userManager.profile.profile.familyName = familyName
                    userManager.profile.profile.jobTitle = jobTitle
                    userManager.profile.profile.about = about
                    // Save the new information
                    Task {
                        await userManager.profile.save()
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(about.count > 512)
            }
        }
    }
}

//struct EditProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditProfileView()
//    }
//}
