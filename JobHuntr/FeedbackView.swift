//
//  FeedbackView.swift
//  JobHuntr
//
//  Created by Adam Ali on 17/03/2023.
//

import SwiftUI

struct FeedbackView: View {
    @EnvironmentObject var userManager: UserManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var feedback: Feedback = Feedback(type: .generalFeedback, message: "", userID: "")
    
    var body: some View {
        Form {
            Picker(selection: $feedback.type, label: Text("Type of Feedback")) {
                Text("General Feedback").tag(FeedbackType.generalFeedback)
                Text("Feature Request").tag(FeedbackType.featureRequest)
                Text("Bug Report").tag(FeedbackType.bugReport)
            }
            
            TextField("Message", text: $feedback.message)
        }
        .navigationTitle("Feedback")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Submit") {
                    feedback.userID = userManager.getUserId()
                    Task {
                        await GlobalDataManager.submitFeedback(feedback: feedback)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(feedback.message.isEmpty)
            }
        }
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
            .environmentObject(UserManager(username: "Dummy", userId: ""))
    }
}
