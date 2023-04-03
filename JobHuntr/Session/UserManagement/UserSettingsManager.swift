//
//  UserSettingsManager.swift
//  JobHuntr
//
//  Created by Adam Ali on 30/03/2023.
//

import Foundation
import Amplify

class UserSettingsManager {
    @Published var settings: UserSettings
    
    init() {
        self.settings = UserSettings(userID: "", colorBlind: false)
    }
    
    /**
     Load the user's saved settings from the DataStore.
     */
    public func load(userId: String) async {
        do {
            // Query the DataStore
            let settings = try await Amplify.DataStore.query(UserSettings.self, where: UserSettings.keys.userID == userId)

            if !settings.isEmpty {
                DispatchQueue.main.async {
                    self.settings = settings[0]
                }
            } else {
                self.settings.userID = userId
                await self.save()
            }
        } catch let error as DataStoreError {
            print("Error fetching user settings. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    /**
     Save a user's settings
     */
    public func save() async {
        do {
            try await Amplify.DataStore.save(self.settings)
        } catch let error as DataStoreError {
            print("Error saving user's settings. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
}
