//
//  UserEducationManager.swift
//  JobHuntr
//
//  Created by Adam Ali on 29/03/2023.
//

import Foundation
import Amplify

class UserEducationManager: DataManager {
    typealias T = Education
    
    @Published var records: [Education] = []
    
    /**
     Load the Education records for a given user.
     - parameter userId
     */
    public func load(userId: String) async {
        do {
            // Query the DataStore
            let educationRecords = try await Amplify.DataStore.query(Education.self, where: Education.keys.userID == userId)
            
            // Load the records into a locally stored list.
            DispatchQueue.main.async {
                self.records = educationRecords
                print("User education loaded")
            }
        } catch let error as DataStoreError {
            print("Error fetching user education. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    /**
     Save an Education record
     - parameter record
     */
    public func save(record: Education) async {
        // Add the record to the locally stored list.
        DispatchQueue.main.async {
            self.records.removeAll(where: {$0.id == record.id})
            self.records.append(record)
        }
        
        // Save the record to the DataStore.
        do {
            try await Amplify.DataStore.save(record)
        } catch let error as DataStoreError {
            print("Error saving education. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    /**
     Delete an Education record
     - parameter record
     */
    public func delete(record: Education) async {
        DispatchQueue.main.async {
            self.records.removeAll(where: {$0.id == record.id})
        }
        
        do {
            try await Amplify.DataStore.delete(Education.self, where: Education.keys.id == record.id)
        } catch let error as DataStoreError {
            print("Error deleting education from DataStore. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
}
