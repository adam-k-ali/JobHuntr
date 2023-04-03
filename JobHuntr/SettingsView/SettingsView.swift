//
//  SettingsViewq.swift
//  JobHuntr
//
//  Created by Adam Ali on 03/03/2023.
//

import SwiftUI
import Amplify

struct SettingsView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var userManager: UserManager
    
    @State var showFeedbackForm: Bool = false
    @State var showingDeleteAccount: Bool = false
    
    var body: some View {
        switch sessionManager.authState {
        case .session:
            AuthSettingsView()
                .environmentObject(sessionManager)
                .environmentObject(userManager)
        default:
            UnAuthSettingsView()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
                .environmentObject(SessionManager())
                .environmentObject(UserManager())
        }
    }
}
