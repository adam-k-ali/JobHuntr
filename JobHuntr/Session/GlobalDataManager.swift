//
//  GlobalDataManager.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/03/2023.
//

import Amplify
import Foundation

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
    
    public static func findCompanyByName(name companyName: String) async -> Company? {
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
        if let company = await findCompanyByName(name: company.name) {
            return company.id
        }
        
        // The company doesn't exist; save it.
        do {
            try await Amplify.DataStore.save(company)
        } catch let error as DataStoreError {
            print("Unable to save company - \(error)")
        } catch {
            print("Unexpected error - \(error)")
        }
        
        return company.id
    }
}
