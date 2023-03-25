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
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack {
                Spacer()
                Image(uiImage: UIImage(named: "AppLogo") ?? UIImage())
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .frame(width: 128, height: 128)
                Spacer()
                Section {
                    Text(errorMsg)
                        .foregroundColor(.red)
                        .font(.headline)
                    TextField("Username", text: $username)
                        .textFieldStyle(GradientTextFieldBackground(systemImageString: "person"))
                    Spacer()
                    Button("Send E-Mail") {
                        Task {
                            await sessionManager.resetPassword(username: username, errorMsg: $errorMsg)
                        }
                        if errorMsg.isEmpty {
                            sessionManager.showConfirmReset(username: username)
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button("Cancel") {
                        sessionManager.showLogin()
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
            }
            .padding()
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
            .environmentObject(SessionManager())
    }
}
