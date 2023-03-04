//
//  ResetPasswordView.swift
//  JobHuntr
//
//  Created by Adam Ali on 03/03/2023.
//

import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var username = ""
    @State var errorMsg = ""

    var body: some View {
        VStack {
            Section {
                Text(errorMsg)
                    .foregroundColor(.red)
                    .font(.headline)
                Text("Enter your username")
                TextField("Username", text: $username)
                Button("Send E-Mail") {
                    Task {
                        await sessionManager.resetPassword(username: username, errorMsg: $errorMsg)
                    }
                    if errorMsg.isEmpty {
                        sessionManager.showConfirmReset(username: username)
                    }
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
