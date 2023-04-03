//
//  UserApplicationManager.swift
//  JobHuntr
//
//  Created by Adam Ali on 30/03/2023.
//

import Foundation
import Amplify

class UserApplicationManager: ObservableObject, DataManager {
    typealias T = Application
    
    @Published var records: [Application] = []
    
    func load(userId: String) async {
        do {
            // Query the DataStore
            let applications = try await Amplify.DataStore.query(Application.self, where: Application.keys.userID == userId, sort: .ascending(Application.keys.currentStage))
            
            DispatchQueue.main.async {
                self.records = applications
            }
        } catch let error as DataStoreError {
            AnalyticsManager.logDataStoreError(error: error, message: "Error loading applications")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    func save(record: Application) async {
        // Check if the application already exists (for analytics)
        let exists = self.records.first(where: {$0.id == record.id}) != nil
        
        // Update the local list of applications
        DispatchQueue.main.async {
            self.records.removeAll(where: {$0.id == record.id})
            self.records.append(record)
            self.records.sort(by: {$0.currentStage! < $1.currentStage!})
        }
        
        // Update the application on the cloud
        do {
            try await Amplify.DataStore.save(record)
            if exists {
                AnalyticsManager.logUpdateApplicationEvent(applicationId: record.id, newStage: record.currentStage!)
            } else {
                Task {
                    let company = await GlobalDataManager.companyFromId(id: record.id)
                    
                    let companyName = company?.name ?? "??"
                    AnalyticsManager.logNewApplicationEvent(jobTitle: record.jobTitle!, companyName: companyName)
                }
            }
        } catch let error as DataStoreError {
            AnalyticsManager.logDataStoreError(error: error, message: "Error saving application")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    func delete(record: Application) async {
        print("Deleting application with id \(record.id) jobTitle: \(record.jobTitle!)")
        DispatchQueue.main.async {
            // Delete the application from the local list of applications
            self.records.removeAll(where: {$0.id == record.id})
        }
                
        // Delete the application from the cloud
        do {
            // Delete from the synced datastore.
            try await Amplify.DataStore.delete(record)
        } catch let error as DataStoreError {
            print("Error deleting application. \(error)")
            AnalyticsManager.logDataStoreError(error: error, message: "Error deleting application")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
}
