//
//  GlobalDataManager.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/03/2023.
//

import Amplify
import Foundation

protocol DataManager {
    associatedtype T
        
    /// Load the data for given userId.
    func load(userId: String) async;
    func save(record: T) async;
    func delete(record: T) async;
}

/// Manages data that belongs to all users
class GlobalDataManager {
    /**
     Load a company from a DataStore from it's ID.
     - parameter id: The company ID
     - returns The company information or nil.
     */
    public static func fetchCompany(id companyID: String) async -> Company? {
        let companyKeys = Company.keys
        do {
            
            let company = try await Amplify.DataStore.query(Company.self, where: companyKeys.id == companyID)
            if company.isEmpty {
                return nil
            }
            return company[0]
        } catch let error as DataStoreError {
            print("Error finding company \(error)")
        } catch {
            print("Unexpected Error \(error)")
        }
        return nil
    }
    
    public static func companyFromName(name companyName: String) async -> Company? {
        let companyKeys = Company.keys
        do {
            let company = try await Amplify.DataStore.query(Company.self, where: companyKeys.name == companyName)
            if company.isEmpty {
                return nil
            }
            return company[0]
        } catch let error as DataStoreError {
            print("Error finding company by name \(error)")
        } catch {
            print("Unexpected Error \(error)")
        }
        return nil
    }
    
    /**
     Saves the company if it doesn't already exist.
     - parameter company: The company information to save, or to load from the DataStore.
     - returns the company ID
     */
    public static func saveOrFetchCompany(company: Company) async -> String {
        // Check if the company already exists.
        if let company = await companyFromName(name: company.name) {
            return company.id
        }
        
        // The company doesn't exist; save it.
        do {
            try await Amplify.DataStore.save(company)
            AnalyticsManager.logNewCompanyEvent(companyName: company.name)
        } catch let error as DataStoreError {
            print("Unable to save company - \(error)")
        } catch {
            print("Unexpected error - \(error)")
        }
        
        return company.id
    }
    
    public static func companyIdFromName(name: String) async -> String {
        let company = Company(name: name, website: "", email: "", phone: "")
        return await GlobalDataManager.saveOrFetchCompany(company: company)
    }
    
    public static func companyFromId(id: String) async -> Company? {
        print("Finding company record from id: \(id)")
        let companyKeys = Company.keys
        do {
            let company = try await Amplify.DataStore.query(Company.self, where: companyKeys.id == id)
            if company.isEmpty {
                return nil
            }
            print("Company found.")
            return company[0]
        } catch let error as DataStoreError {
            print("Error finding company by id \(error)")
        } catch {
            print("Unexpected Error \(error)")
        }
        return nil
    }
    
    public static func submitFeedback(feedback: Feedback) async {
        do {
            try await Amplify.DataStore.save(feedback)
        } catch let error as DataStoreError {
            print("Unable to submit feedback. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    public static func fetchSkillName(id: String) async -> String? {
        do {
            let skill = try await Amplify.DataStore.query(Skill.self, where: Skill.keys.id == id)
            
            if !skill.isEmpty {
                return skill[0].name
            }
        } catch let error as DataStoreError {
            print("Unable to find skill. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
        return nil
    }
    
    /**
     Fetchs the skill ID from the datastore or creates a new one, having saved it to the datastore.
     */
    public static func fetchOrSaveSkill(name: String) async -> String? {
        do {
            // Check for an already-saved skill
            let savedSkill = try await Amplify.DataStore.query(Skill.self, where: Skill.keys.name == name.lowercased())
            
            if !savedSkill.isEmpty {
                return savedSkill[0].id
            }
            
            // No skill found - create a new one
            let newSkill = Skill(name: name.lowercased(), rank: 0.0)
            try await Amplify.DataStore.save(newSkill)
            
            return newSkill.id
        } catch let error as DataStoreError {
            print("Unable to fetch skill. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
        
        return nil
    }
}
