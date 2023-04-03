//
//  UserSkillsManager.swift
//  JobHuntr
//
//  Created by Adam Ali on 29/03/2023.
//

import Foundation
import Amplify

// TODO: All functions need completing - this is a bit more complicated than education/courses/jobs hahaha
class UserSkillsManager: ObservableObject, DataManager {
    typealias T = String
    
    @Published var records: [String] = []
    
    var userId: String = ""
    
    func load(userId: String) async {
        do {
            // Query the DataStore for all skill IDs the user has
            let skills = try await Amplify.DataStore.query(UserSkills.self, where: UserSkills.keys.userID == userId)
            
            // Convert these skills to skill names
            var skillNames: [String] = []
            for skill in skills {
                let skillName = await GlobalDataManager.fetchSkillName(id: skill.skillID)
                if skillName != nil {
                    skillNames.append(skillName!)
                }
            }
            
            let result = skillNames
            DispatchQueue.main.async {
                self.records = result
                self.userId = userId
                print("User skills loaded")
            }
        } catch let error as DataStoreError {
            print("Error fetching user skills. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }

    }
    
    /**
     Save a user skill
     */
    func save(record: String) async {
        // Save to local `records`
        DispatchQueue.main.async {
            self.records.removeAll(where: {$0 == record.lowercased()})
            self.records.append(record.lowercased())
        }
        
        // Save to DataStore
        let skillId = await GlobalDataManager.fetchOrSaveSkill(name: record.lowercased())
        if skillId == nil {
            return
        }
        
        if await hasSkill(skillId: skillId!) {
            print("User already has skill")
            return
        }
        
        let skill = UserSkills(userID: self.userId, skillID: skillId!)

        do {
            try await Amplify.DataStore.save(skill)
        } catch let error as DataStoreError {
            print("Error saving skill. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    func delete(record: String) async {
        // Delete locally
        DispatchQueue.main.async {
            self.records.removeAll(where: {$0 == record.lowercased()})
        }
        
        // Delete from cloud and DataStore
        do {
            let skillId = await GlobalDataManager.fetchOrSaveSkill(name: record.lowercased())
            
            try await Amplify.DataStore.delete(UserSkills.self, where: UserSkills.keys.userID == self.userId && UserSkills.keys.skillID == skillId)
        } catch let error as DataStoreError {
            print("Error deleting skill from DataStore. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    private func hasSkill(skillId: String) async -> Bool {
        do {
            let skills = try await Amplify.DataStore.query(UserSkills.self, where: UserSkills.keys.userID == self.userId && UserSkills.keys.skillID == skillId)
            if !skills.isEmpty {
                return true
            }
            return false
        } catch let error as DataStoreError {
            print("Error fetching user skills. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
        return false
    }
    
}
    
