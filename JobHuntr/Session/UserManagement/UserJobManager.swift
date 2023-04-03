//
//  UserJobManager.swift
//  JobHuntr
//
//  Created by Adam Ali on 29/03/2023.
//

import Foundation
import Amplify

class UserJobManager: ObservableObject, DataManager {
    typealias T = Job
    
    @Published var records: [Job] = []
    
    func load(userId: String) async {
        do {
            // Query the DataStore
            let jobs = try await Amplify.DataStore.query(Job.self, where: Job.keys.userID == userId)
            
            DispatchQueue.main.async {
                self.records = jobs
                print("User education loaded")
            }
        } catch let error as DataStoreError {
            print("Error fetching user jobs. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    func save(record: Job) async {
        DispatchQueue.main.async {
            self.records.removeAll(where: {$0.id == record.id})
            self.records.append(record)
        }
        
        do {
            try await Amplify.DataStore.save(record)
        } catch let error as DataStoreError {
            print("Error saving job. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    func delete(record: Job) async {
        // Delete locally
        DispatchQueue.main.async {
            self.records.removeAll(where: {$0.id == record.id})
        }
        
        // Delete from cloud and DataStore
        do {
            try await Amplify.DataStore.delete(Job.self, where: Job.keys.id == record.id)
        } catch let error as DataStoreError {
            print("Error deleting education from DataStore. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
}
    
