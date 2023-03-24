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
                            .foregroundColor(AppColors.fontColor)
                    }
                } else {
                    ForEach($userManager.applications) { $application in
                        NavigationLink(destination: ApplicationDetailView(application: $application).environmentObject(userManager)) {
                            ListCard(isChangeable: true, onDelete: {
                                showingDeleteAlert = true
                            }) {
                                ApplicationCardView(application: $application.wrappedValue)
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
            .padding()
        }
        .navigationTitle("Applications")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(action: {
                isPresentingNewAppView = true
            }) {
                Image(systemName: "plus")
            }
        }
        .colorScheme(.dark)
        .sheet(isPresented: $isPresentingNewAppView) {
            NavigationView {
                NewApplicationView()
                    .environmentObject(userManager)
            }
            .colorScheme(.dark)
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

