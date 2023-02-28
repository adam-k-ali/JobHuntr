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
        VStack(alignment: .center) {
            if isRefreshing {
                ProgressView()
            }
            List {
                if applications.isEmpty {
                    Text("No Applications Found.")
                } else {
                    ForEach($applications, id: \.id) { $application in
                        NavigationLink(destination: ApplicationDetailView(application: $application).environmentObject(sessionManager)) {
                            ApplicationCardView(application: $application)
                                .contextMenu {
                                    Button(action: {
                                        showingDeleteAlert = true
                                    }) {
                                        Label("Delete", systemImage: "trash.fill")
                                    }
                                }
                                .actionSheet(isPresented: $showingDeleteAlert) {
                                    ActionSheet(title: Text("Delete Application?"), message: Text("Are you sure you want to delete this application?"), buttons: [
                                        .default(Text("OK"), action: {
                                            Task {
                                                await sessionManager.deleteApplication(application: application)
                                                await refreshApplications()
                                            }
                                        }),
                                        .cancel()
                                    ])
                                }
                        }
                    }
                    .onDelete(perform: delete)
                }
            }
            
            
        }
        .navigationTitle("Applications")
        .onAppear {
            Task {
                await queryApplications()
            }
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
            .onDisappear{
                Task {
                    await refreshApplications()
                }
            }
        }
        
        
    }
    
    func delete(at offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        let application = self.applications[index]
        print(application.id)
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

struct ApplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ApplicationsView(user: DummyUser())
        }
    }
}
