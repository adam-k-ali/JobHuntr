//
//  ApplicationsView.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/02/2023.
//

import Amplify
import SwiftUI

struct ApplicationsView: View {
    @EnvironmentObject var userManager: UserManager
    
    @State private var isRefreshing = false
        
    @State private var isPresentingNewAppView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        List {
            if userManager.applications.isEmpty {
                Text("No Applications Found.")
            } else {
                ForEach($userManager.applications) { $application in
                    NavigationLink(destination: ApplicationDetailView(application: $application).environmentObject(userManager)) {
                        ApplicationCardView(application: $application.wrappedValue)
                            .contextMenu {
                                Button(action: {
                                    showingDeleteAlert = true
                                }) {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                    }
                    .actionSheet(isPresented: $showingDeleteAlert) {
                        // Confirmation of deletion
                        ActionSheet(title: Text("Delete Application?"), message: Text("Are you sure you want to delete this application?"), buttons: [
                            .default(Text("OK"), action: {
                                Task {
                                    await userManager.deleteApplication(application: application)
                                }
                            }),
                            .cancel()
                        ])
                    }
                }
            }
        }
        .navigationTitle("Applications")
        .toolbar {
            Button(action: {
                isPresentingNewAppView = true
            }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $isPresentingNewAppView) {
            NavigationView {
                NewApplicationView()
                    .environmentObject(userManager)
            }
        }
    }
    
}

//struct ApplicationsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ApplicationsView(user: DummyUser())
//        }
//    }
//}

