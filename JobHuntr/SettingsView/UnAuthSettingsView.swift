//
//  UnAuthSettingsView.swift
//  JobHuntr
//
//  Created by Adam Ali on 03/04/2023.
//

import SwiftUI

/// The settings view a user sees if they're not signed in
struct UnAuthSettingsView: View {
    @State var showFeedbackForm: Bool = false
    @State var showingDeleteAccount: Bool = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading) {
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
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $showFeedbackForm) {
            NavigationView {
                FeedbackView()
            }
        }
        .navigationTitle("Settings")
    }
}

struct UnAuthSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UnAuthSettingsView()
    }
}
