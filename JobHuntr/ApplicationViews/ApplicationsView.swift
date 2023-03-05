//
//  ApplicationsView.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/02/2023.
//

import Amplify
import SwiftUI

struct ApplicationsView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    @State private var applications: [Application] = []
    @State private var isRefreshing = false
    
    let user: AuthUser
    
    @State private var isPresentingNewAppView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        List {
            if applications.isEmpty {
                Text("No applications found.")
            } else {
                ForEach($applications, id: \.id) { $application in
                    // Create link to ApplicationDetailView
                    NavigationLink(destination: ApplicationDetailView(application: $application).environmentObject(sessionManager)) {
                        // Display the card as the link
                        ApplicationCardView(application: $application)
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
                                    await sessionManager.deleteApplication(application: application)
                                    refreshView()
                                }
                            }),
                            .cancel()
                        ])
                    }
                }
                .onDelete(perform: delete)
            }
        }
        .navigationTitle("Applications (\(applications.count))")
        .onAppear {
            refreshView()
        }
        .toolbar {
            Button(action: {
                isPresentingNewAppView = true
            }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $isPresentingNewAppView) {
            NavigationView {
                NewApplicationView(user: user)
                    .environmentObject(sessionManager)
            }
            .onDisappear {
                refreshView()
            }
        }
    }
    
    func refreshView() {
        Task {
            await refreshApplications()
        }
    }
    
    func delete(at offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        let application = self.applications[index]
        print("Deleting application: \(application)")
        Task {
            await sessionManager.deleteApplication(application: application)
        }
        applications.remove(atOffsets: offsets)
    }
    
    func queryApplications() async {
        applications = await sessionManager.fetchAllApplications(user)
    }
    
    func refreshApplications() async {
        isRefreshing = true
        await queryApplications()
        isRefreshing = false
    }
}

//struct ApplicationsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ApplicationsView(user: DummyUser())
//        }
//    }
//}

