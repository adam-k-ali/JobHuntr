//
//  UserManager.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/03/2023.
//

import Amplify
import SwiftUI
import Foundation


/// Manages the user's properties throughout their session.
class UserManager: ObservableObject {
    /**
     Default user settings
     */
    static let defaultSettings: UserSettings = UserSettings(userID: "", colorBlind: false)
    
    static let defaultProfile: UserProfile = UserProfile(userID: "", givenName: "", lastName: "", profilePicture: "", jobTitle: "")
    
    private var user: AuthUser
    
    /// The user's settings
    @Published public var settings: UserSettings = defaultSettings
    
    /// The user's profile
    @Published public var profile: UserProfile = defaultProfile
    
    /// The user's profile picture
    @Published public var profilePic: UIImage = UIImage(systemName: "person.crop.circle.fill")!
    
    /// The user's applications
    @Published public var applications: [Application] = []
    @Published public var streak: Int = 0
    @Published public var numApplications: Int = 0
    
    @Published public var isLoading: Bool = true
    
    /**
     Initialize management of a given user.
     - parameter user: The AuthUser to manage.
     */
    init(user: AuthUser) {
        self.user = user
        Task {
            await self.loadUserProfile {
                Task {
                    await self.downloadUserData {
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    private func downloadUserData(completion: @escaping() -> ()) async {
        await self.downloadProfilePicture()
        await self.loadUserApplications()
        await self.loadUserSettings()
        DispatchQueue.main.async {
            self.getUserProfilePicture()
            completion()
        }
    }
    
    public func getUserId() -> String {
        return user.userId
    }
    
    public func getUsername() -> String {
        return user.username
    }
    
    // ======================================================
    // Profile Management
    // ======================================================
    
    /**
     Load the user's profile from the DataStore
     */
    private func loadUserProfile(completion: @escaping() -> ()) async {
        do {
            // Query the DataStore
            let profile = try await Amplify.DataStore.query(UserProfile.self, where: UserProfile.keys.userID == user.userId)
            
            DispatchQueue.main.async {
                if !profile.isEmpty {
                        self.profile = profile[0]
                } else {
                    var profile = UserManager.defaultProfile
                    profile.userID = self.user.userId
                    self.profile = profile
                }
                print("User profile loaded. \(self.profile)")
                completion()
            }
        } catch let error as DataStoreError {
            print("Error fetching user profile. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    /**
     Save the user's profile to the DataStore
     */
    public func saveUserProfile() async {
        do {
            print("Saving user profile. \(self.profile)")
            try await Amplify.DataStore.save(self.profile)
            print("Complete.")
        } catch let error as DataStoreError {
            print("Error saving user's profile. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    public func uploadProfilePicture(image: UIImage) async {
        do {
            print("Uploading profile picture")
            let imageName = UUID().uuidString
            let imageData = image.jpegData(compressionQuality: 1)!
            
            let uploadTask = Amplify.Storage.uploadData(
                key: imageName,
                data: imageData
            )
            Task {
                for await progress in await uploadTask.progress {
                    print("Progress: \(progress)")
                }
            }
            let value = try await uploadTask.value
            print("Completed: \(value)")
            
            DispatchQueue.main.async {
                self.profile.profilePicture = value
                Task {
                    await self.saveUserProfile()
                }
            }
            
        } catch let error as StorageError {
            print("Failed uploading profile picture. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    public func downloadProfilePicture() async {
        do {
            let fileName = self.profile.profilePicture + ".jpeg"
            let downloadToFileName = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
            if FileManager.default.fileExists(atPath: downloadToFileName.path) {
                print("Profile picture is already saved locally.")
                self.getUserProfilePicture()
                return
            }
            print("Downloading \(self.profile.profilePicture)")
            
            let downloadTask = Amplify.Storage.downloadFile(key: self.profile.profilePicture, local: downloadToFileName)
            Task {
                for await progress in await downloadTask.progress {
                    print("Progress: \(progress)")
                }
            }
            try await downloadTask.value
            print("Completed download.")
            
            self.getUserProfilePicture()
        } catch let error as StorageError {
            print("Error downloading profile picture. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    public func getUserProfilePicture() {
        let defaultImage = UIImage(systemName: "person.crop.circle.fill")!
        if self.profile.profilePicture.isEmpty {
            self.profilePic = defaultImage
            print("Using default profile picture")
            return
        }
        let fileName = self.profile.profilePicture + ".jpeg"
        let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        let savedImage = UIImage(contentsOfFile: imageURL.path)
        DispatchQueue.main.async {
            self.profilePic = savedImage != nil ? savedImage! : defaultImage
            print("Profile picture updated")
        }
    }
    
    // ======================================================
    // Settings Management
    // ======================================================
    
    /**
     Load the user's saved settings from the DataStore.
     */
    private func loadUserSettings() async {
        do {
            // Query the DataStore
            let settings = try await Amplify.DataStore.query(UserSettings.self, where: UserSettings.keys.userID == user.userId)

            if !settings.isEmpty {
                DispatchQueue.main.async {
                    self.settings = settings[0]
                }
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
    public func saveUserSettings() async {
        do {
            try await Amplify.DataStore.save(self.settings)
        } catch let error as DataStoreError {
            print("Error saving user's settings. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    // ======================================================
    // Application Management
    // ======================================================
    
    /**
     Load the user's saved applications from the DataStore, updating the local storage.
     */
    private func loadUserApplications() async {
        do {
            // Query the DataStore
            let applications = try await Amplify.DataStore.query(Application.self, where: Application.keys.userID == self.user.userId, sort: .ascending(Application.keys.currentStage))
            
            DispatchQueue.main.async {
                self.applications = applications
                self.numApplications = self.applications.count
                self.streak = self.calculateStreak(applications: self.applications)
            }
        } catch let error as DataStoreError {
            print("Error trying to fetch Applications. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    /**
     Saves or updates a given application.
     - parameter application: The application to save or update.
     - parameter company: The company of the application.
     */
    public func saveOrUpdateApplication(application: Application, company: Company) async {
        // Get the required company ID, whether that's one that's already saved to the cloud, or a new company ID.
        let companyID = await GlobalDataManager.saveOrFetchCompany(company: company)
        
        // Update the application's company ID
        var application = application
        application.companyID = companyID
        
        // Update the local list of applications
        self.applications.removeAll(where: {$0.id == application.id})
        self.applications.append(application)
        self.applications.sort(by: {$0.currentStage! < $1.currentStage!})
        self.numApplications = self.applications.count
        self.streak = calculateStreak(applications: self.applications)
        
        // Update the application on the cloud
        do {
            try await Amplify.DataStore.save(application)
        } catch let error as DataStoreError {
            print("Error saving application. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    /**
     Delete an application
     - parameter application: The application to delete
     */
    public func deleteApplication(application: Application) async {
        // Delete the application from the local list of applications
        self.applications.removeAll(where: {$0.id == application.id})
        
        // Delete the application from the cloud
        do {
            // Delete from the synced datastore.
            try await Amplify.DataStore.delete(application)
        } catch let error as DataStoreError {
            print("Error deleting application. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    /**
     Calculate the number of consecutive days the user has entered a new application.
     */
    private func calculateStreak(applications: [Application]) -> Int {
        var streak = 0
        for application in applications {
            let daysSince = Calendar.current.daysSince(date: application.dateApplied!.foundationDate)
            if daysSince - streak > 1 {
                break
            }
            streak += 1
        }
        return streak
    }
    
}
