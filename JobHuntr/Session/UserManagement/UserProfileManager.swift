//
//  UserProfileManager.swift
//  JobHuntr
//
//  Created by Adam Ali on 30/03/2023.
//

import Foundation
import SwiftUI
import Amplify

class UserProfileManager: ObservableObject {
    @Published var profile: Profile
    @Published public var profilePic: UIImage?
    
    init() {
        self.profile = Profile(userID: "", givenName: "", familyName: "", profilePicture: "", jobTitle: "", about: "")
    }
    
    public func load(userId: String) async {
        do {
            // Query the DataStore
            let profile = try await Amplify.DataStore.query(Profile.self, where: Profile.keys.userID == userId)
            
            DispatchQueue.main.async {
                if !profile.isEmpty {
                        self.profile = profile[0]
                } else {
                    self.profile.userID = userId
                    Task {
                        await self.save()
                    }
                }
                print("User profile loaded. \(self.profile)")
                Task {
                    await self.downloadProfilePicture()
                    
                }
            }
        } catch let error as DataStoreError {
            print("Error fetching user profile. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    private func downloadProfilePicture() async {
        do {
            // The file name to download the image to
            let fileName = self.profile.profilePicture
            let downloadToFileName = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
            
            // Check if the file already exists locally
            if FileManager.default.fileExists(atPath: downloadToFileName.path) {
                print("Profile picture is already saved locally.")
                self.getUserProfilePicture()
                return
            }
            
            // Otherwise download the image from the cloud
            print("Downloading \(self.profile.profilePicture)")
            let downloadTask = Amplify.Storage.downloadFile(key: self.profile.profilePicture, local: downloadToFileName)
            Task {
                for await progress in await downloadTask.progress {
                    print("Progress: \(progress)")
                }
            }
            
            // Await the completion of the download task
            try await downloadTask.value
            print("Completed download.")
            
            // Update the local image instance
            self.getUserProfilePicture()
        } catch let error as StorageError {
            print("Error downloading profile picture. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    private func getUserProfilePicture() {
        let defaultImage = UIImage(systemName: "person.crop.circle.fill")!
        if self.profile.profilePicture.isEmpty {
            DispatchQueue.main.async {
                self.profilePic = defaultImage
            }
            print("Using default profile picture")
            return
        }
        let fileName = self.profile.profilePicture
        let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        let savedImage = UIImage(contentsOfFile: imageURL.path)
        DispatchQueue.main.async {
            self.profilePic = savedImage
            print("Profile picture updated. Using image: \(fileName)")
        }
    }

    
    public func save() async {
        do {
            print("Saving profile - \(self.profile)")
            try await Amplify.DataStore.save(self.profile)
        } catch let error as DataStoreError {
            print("Error saving user's profile. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    public func saveProfilePicture() async {
        do {
            if self.profilePic == nil {
                print("No profile picture to save.")
                return
            }
            print("Uploading profile picture")
            // Create image ID and get the image data
            let imageName = UUID().uuidString + ".jpeg"
            let imageData = self.profilePic?.jpegData(compressionQuality: 0.6)
            
            if imageData == nil {
                print("Error getting image data.")
                return
            }
            
            // Upload the image; start upload task
            let uploadTask = Amplify.Storage.uploadData(
                key: imageName,
                data: imageData!
            )
            // Track upload progress
            Task {
                for await progress in await uploadTask.progress {
                    print("Progress: \(progress)")
                }
            }
            let value = try await uploadTask.value
            print("Upload Completed: \(value)")
            
            // Update the local storage
            DispatchQueue.main.async {
                self.profile.profilePicture = value
                Task {
                    await self.save()
                }
            }
            
        } catch let error as StorageError {
            print("Failed uploading profile picture. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
}
