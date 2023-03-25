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
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack(spacing: 24) {
                Spacer()
                Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .frame(width: 128, height: 128)
                Spacer()
                Section {
                    Text("Check your e-mail for a confirmation code.")
                        .font(.headline)
                        .foregroundColor(AppColors.fontColor)
//                    Text("Username: \(username)")
                    TextField("Confirmation Code", text: $confirmationCode)
                        .textFieldStyle(GradientTextFieldBackground(systemImageString: "number"))
                    Text(error)
                        .font(.headline)
                        .foregroundColor(.red)
                }
                Spacer()
                
                Button("Confirm", action: {
                    Task {
                        await sessionManager.confirmSignUp(for: username, with: confirmationCode, errorMsg: $error)
                    }
                })
                .buttonStyle(PrimaryButtonStyle())
                Button("Cancel", action: {
                    sessionManager.showLogin()
                })
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding()
        }
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(username: "??")
    }
}
