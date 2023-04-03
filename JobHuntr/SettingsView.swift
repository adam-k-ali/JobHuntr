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
        ZStack {
            AppColors.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading) {
                    // Account
                    Section(header:
                        Text("ACCOUNT MANAGEMENT")
                        .font(.caption)
                        .padding([.top, .leading])
                    ) {
                        ListCard {
                            Button("Sign Out") {
                                Task {
                                    await sessionManager.signOut()
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        
                    }
                    
                    // Other
                    Section(header:
                        Text("GENERAL")
                        .font(.caption)
                        .padding([.top, .leading])
                    ) {
                        ListCard {
                            Button {
                                showFeedbackForm = true
                            } label: {
                                Text("Send Feedback")
                            }
                            .buttonStyle(.plain)
                        }
                        
                    }
                    
                    Section(header:
                        Text("PRIVACY")
                        .font(.caption)
                        .padding([.top, .leading])
                    ) {
                        ListCard {
                            Link("Privacy Policy", destination: URL(string: "https://adamkali.com/privacy-policy")!)
                                .buttonStyle(.plain)
                        }
                        ListCard {
                            Button("Delete Account") {
                                Task {
                                    showingDeleteAccount = true
                                }
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
                .padding()
            }
        }
        .actionSheet(isPresented: $showingDeleteAccount) {
            // Confirmation of deletion
            ActionSheet(title: Text("Delete Account?"), message: Text("Are you sure you want to delete your account?"), buttons: [
                .destructive(Text("Delete"), action: {
                    Task {
                        await sessionManager.deleteUser()
                    }
                }),
                .cancel()
            ])
        }
        .onAppear {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                AnalyticsManager.logViewSettingsEvent()
            }
        }
//        .onDisappear {
//            // TODO: Replace this with a 'save' button in toolbar?
//            Task {
//                await userManager.settings.save()
//            }
//        }
        .sheet(isPresented: $showFeedbackForm) {
            NavigationView {
                FeedbackView()
                    .environmentObject(userManager)
            }
        }
        .navigationTitle("Settings")
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
