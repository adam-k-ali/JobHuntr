//
//  ContentView.swift
//  JobHuntr
//
//  Created by Adam Ali on 17/03/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        if !userManager.isLoading {
            MainMenuView()
                .environmentObject(sessionManager)
                .environmentObject(userManager)
        } else {
            LoadingView()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environmentObject(SessionManager())
//            .environmentObject(UserManager(user: DummyUser()))
//    }
//}
