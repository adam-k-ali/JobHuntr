//
//  UpdateApplicationView.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/02/2023.
//

import Amplify
import SwiftUI

struct UpdateApplicationView: View {
    @EnvironmentObject var userManager: UserManager
    
    @Binding var application: Application
    @State var applicationStage: ApplicationStage = .applied
    @Environment(\.presentationMode) var presentationMode
    
    let stages: [ApplicationStage] = [.applied, .preInterview, .interviewing, .offer, .accepted, .rejection]
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack {
                Picker("Stage", selection: $applicationStage) {
                    ForEach(stages, id: \.self) { stage in
                        Text(stage.name)
                    }
                }
                .pickerStyle(.wheel)
                Spacer()
            }
        }
        .onAppear {
            applicationStage = application.currentStage!
        }
        .navigationTitle("Update Application")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Update") {
                    Task {
                        application.currentStage = applicationStage
                        await userManager.saveOrUpdateApplication(application: application, company: nil)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(application.currentStage! == applicationStage)
            }
        }
    }
}

//struct UpdateApplicationView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpdateApplicationView(application: .constant(Application.sampleApplication))
//    }
//}
