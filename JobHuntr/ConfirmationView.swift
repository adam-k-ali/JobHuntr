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
    
    let username: String
    
    var body: some View {
        VStack {
            Section {
                Text("Username: \(username)")
                TextField("Confirmation Code", text: $confirmationCode)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Confirm", action: {
                Task {
                    await sessionManager.confirmSignUp(for: username, with: confirmationCode)
                }
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
