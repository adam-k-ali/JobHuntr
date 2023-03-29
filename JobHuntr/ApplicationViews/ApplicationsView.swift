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
        ZStack {
            AppColors.background.ignoresSafeArea()
            ScrollView {
                if userManager.applications.isEmpty {
                    ListCard {
                        Text("No Applications Found.")
                    }
                } else {
                    ForEach($userManager.applications) { $application in
                        NavigationLink(destination: ApplicationDetailView(application: $application).environmentObject(userManager)) {
                            ApplicationCardView(application: $application.wrappedValue)
                                .contextMenu {
                                    Button(action: {
                                        showingDeleteAlert = true
                                    }, label: {
                                        Image(systemName: "trash")
                                        Text("Delete")
                                    })
                                }
                        }
                        .buttonStyle(.plain)
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
            .padding()
        }
        .onAppear {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                AnalyticsManager.logViewApplicationsEvent()
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

struct ApplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ApplicationsView()
                .environmentObject(UserManager())
        }
    }
}

