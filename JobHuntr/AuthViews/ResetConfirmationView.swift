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
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack {
                Spacer()
                
                Image(uiImage: UIImage(named: "AppLogo") ?? UIImage())
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .frame(width: 128, height: 128)
                
                Spacer()
                
                Group {
                    Text("Check your e-mail for a confirmation code")
                        .font(.headline)
                        .foregroundColor(AppColors.fontColor)
                    TextField("Confirmation Code", text: $confirmationCode)
                        .textFieldStyle(GradientTextFieldBackground(systemImageString: "number"))
                    SecureInputView("New Password", text: $newPassword)
                        .textFieldStyle(GradientTextFieldBackground(systemImageString: "key"))
                    SecureInputView("Confirm Password", text: $newPasswordConfirm)
                        .textFieldStyle(GradientTextFieldBackground(systemImageString: "key"))
                }
                
                Text(error)
                    .font(.headline)
                    .foregroundColor(.red)
                
                Spacer()
                
                Group {
                    Button(action: confirm, label: {Text("Reset Password")})
                        .buttonStyle(PrimaryButtonStyle())
                    Button(action: cancel, label: {Text("Cancel")})
                        .buttonStyle(SecondaryButtonStyle())
                }
            }
            .padding()
        }
    }
    
    func cancel() {
        sessionManager.showLogin()
    }
    
    func confirm() {
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
    }
}

struct ResetConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ResetConfirmationView(username: "")
            .environmentObject(SessionManager())
    }
}
