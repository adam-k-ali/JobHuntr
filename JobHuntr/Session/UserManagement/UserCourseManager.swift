//
//  UserCourseManager.swift
//  JobHuntr
//
//  Created by Adam Ali on 29/03/2023.
//

import Foundation
import Amplify

class UserCourseManager: ObservableObject, DataManager {
    typealias T = Course
    
    @Published var records: [String: [Course]] = [:]
    
    /**
     Load the courses for a given user
     - parameter userId
     */
    func load(userId: String) async {
        do {
            // Get Education IDs for the user
            let educationRecords = try await Amplify.DataStore.query(Education.self, where: Education.keys.userID == userId)
            
            // For each Education record
            educationRecords.forEach { record in
                Task {
                    // Load courses and add to `records`
                    let courses = try await Amplify.DataStore.query(Course.self, where: Course.keys.educationID == record.id)
                    DispatchQueue.main.async {
                        self.records[record.id] = courses
                    }
                }
                
            }
        } catch let error as DataStoreError {
            print("Error fetching user education courses. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    func save(record: Course) async {
        let educationId = record.educationID
        
        // Save to `records` locally
        if records.keys.contains(educationId) {
            records[educationId]?.removeAll(where: {$0.id == record.id})
        } else {
            records[educationId] = []
        }
        records[educationId]?.append(record)
        
        do {
            try await Amplify.DataStore.save(record)
        } catch let error as DataStoreError {
            print("Error saving course. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
        
    }
    
    public func lazyCoursesForEducation(educationId: String) -> [Course] {
        return self.records[educationId] ?? []
    }
    
    func delete(record: Course) async {
        // Remove course from local `records`
        DispatchQueue.main.async {
            self.records[record.educationID]?.removeAll(where: {$0.id == record.id})
        }
        
        // Remove course from cloud
        do {
            try await Amplify.DataStore.delete(Course.self, where: Course.keys.id == record.id)
        } catch let error as DataStoreError {
            print("Error deleting course from DataStore. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
}
