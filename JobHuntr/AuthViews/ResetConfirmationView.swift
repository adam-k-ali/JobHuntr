//
//  ResetConfirmationView.swift
//  JobHuntr
//
//  Created by Adam Ali on 03/03/2023.
//

import SwiftUI

struct ResetConfirmationView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var confirmationCode = ""
    @State var error = ""
    @State var newPassword = ""
    @State var newPasswordConfirm = ""
    
    let username: String
    
    var body: some View {
        VStack {
            Section {
                Text("Check your e-mail for a confirmation code.")
                Text("Username: \(username)")
                TextField("Confirmation Code", text: $confirmationCode)
                SecureField("New Password", text: $newPassword)
                SecureField("Confirm Password", text: $newPasswordConfirm)
                Text(error)
                    .font(.headline)
                    .foregroundColor(.red)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack {
                Button("Cancel", action: {
                    sessionManager.showLogin()
                })
                Spacer()
                Button("Confirm", action: {
                    if newPassword != newPasswordConfirm {
                        error = "Passwords don't match"
                        return
                    }
                    Task {
                        await sessionManager.confirmResetPassword(username: username, newPassword: newPassword, confirmationCode: confirmationCode, errorMsg: $error)
                    }
                    if error.isEmpty {
                        sessionManager.showLogin()
                    }
                })
            }
        }
        .padding()

    }
}
//
//struct ResetConfirmationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResetConfirmationView()
//    }
//}
