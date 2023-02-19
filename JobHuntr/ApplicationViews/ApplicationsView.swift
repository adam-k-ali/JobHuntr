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
        VStack {
            List {
                if applications.isEmpty {
                    Text("No Applications Found.")
                } else {
                    ForEach($applications, id: \.id) { $application in
                        NavigationLink(destination: ApplicationDetailView(application: $application).environmentObject(sessionManager)) {
                            ApplicationCardView(application: $application)
                                .swipeActions {
                                    Button {
                                        showingDeleteAlert = true
                                        Task {
                                            await sessionManager.deleteApplication(application: application)
                                        }
                                        // TODO: Refresh
                                    } label: {
                                        Image(systemName: "xmark.bin.fill")
                                    }
                                    .tint(.red)
                                    .alert("Delete Not Implemented", isPresented: $showingDeleteAlert) {
                                        Button("OK", role: .cancel) { }
                                    }
                                }
                        }
                    }
                }
            }
        }
        .navigationTitle("Applications")
        .refreshable {
            await refreshApplications()
        }
        .overlay {
            ProgressView()
                .opacity(isRefreshing ? 1 : 0)
        }
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
        }
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
