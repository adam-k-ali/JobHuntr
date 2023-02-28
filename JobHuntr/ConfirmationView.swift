//
//  ConfirmationView.swift
//  JobHuntr
//
//  Created by Adam Ali on 14/02/2023.
//

import SwiftUI

struct ConfirmationView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var confirmationCode = ""
    @State var error = ""
    
    let username: String
    
    var body: some View {
        VStack {
            Section {
                Text("Check your e-mail for a confirmation code.")
                Text("Username: \(username)")
                TextField("Confirmation Code", text: $confirmationCode)
                Text(error)
                    .font(.headline)
                    .foregroundColor(.red)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Confirm", action: {
                Task {
                    await sessionManager.confirmSignUp(for: username, with: confirmationCode, errorMsg: $error)
                }
            })
            Button("Cancel", action: {
                sessionManager.showLogin()
            })
        }
        .padding()
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(username: "??")
    }
}
