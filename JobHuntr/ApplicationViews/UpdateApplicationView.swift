//
//  UpdateApplicationView.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/02/2023.
//

import Amplify
import SwiftUI

struct UpdateApplicationView: View {
    var application: Application
    @State var applicationStage: ApplicationStage = .applied
    @Environment(\.presentationMode) var presentationMode
    
    let stages: [ApplicationStage] = [.applied, .preInterview, .interviewing, .offer, .accepted, .rejection]
    
    init(application: Application) {
        self.application = application
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Application Stage")) {
                    Picker("Stage", selection: $applicationStage) {
                        ForEach(stages, id: \.self) { stage in
                            Text(stageName(stage: stage))
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Update") {
                    Task {
                        await updateApplication()
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    func updateApplication() async {
        do {
            print("updating application...")
            let newApplication = Application(id: application.id, currentStage: applicationStage)
            print("Created updated application")
            try await Amplify.DataStore.save(newApplication, where: Application.keys.userID == application.userID && Application.keys.id == application.id)
            print("Updated application successfully")
        } catch let error as DataStoreError {
            print("Couldn't update application \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
    }
    
    func stageName(stage: ApplicationStage) -> String {
        switch stage {
        case .applied:
            return "Applied"
        case .preInterview:
            return "Pre-Interview"
        case .interviewing:
            return "Interviewing"
        case .offer:
            return "Offer Received"
        case .accepted:
            return "Accepted"
        case .rejection:
            return "Rejected"
        }
    }
}

struct UpdateApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateApplicationView(application:
            Application.sampleApplication
        )
    }
}
