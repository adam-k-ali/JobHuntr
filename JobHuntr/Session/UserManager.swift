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
    
    static let defaultProfile: Profile = Profile(userID: "", givenName: "", familyName: "", profilePicture: "", jobTitle: "", about: "")
    
    private var username: String = ""
    private var userId: String = ""
    
    private var isSignedIn: Bool = false
    
    /// The user's settings
    @Published public var settings: UserSettings = defaultSettings
    
    /// The user's profile
    @Published public var profile: Profile = defaultProfile
    
    /// The user's profile picture
    @Published public var profilePic: UIImage?
    
    /// The user's applications
    @Published public var applications: [Application] = []
    @Published public var streak: Int = 0
    @Published public var numApplications: Int = 0
    
    /// The user's education history
    @Published public var education: [Education] = []
    
    @Published public var courses: [String: [Course]] = [:]
    
    /// The user's job history
    @Published public var jobs: [Job] = []
    
    /// The user's skills
    @Published public var skills: [String] = []
    
    @Published public var isLoading: Bool = true
    
    public func load(username: String, userId: String, completion: @escaping () -> Void) {
        self.username = username
        self.userId = userId
        if userId.isEmpty {
            return
        }
        Task {
            await self.loadUserProfile {
                Task {
                    await self.downloadUserData {
                        self.isLoading = false
                        self.isSignedIn = true
                        completion()
                    }
                }
            }
        }
    }
    
    private func downloadUserData(completion: @escaping() -> ()) async {
        await self.downloadProfilePicture()
        await self.loadUserSettings()
        await self.loadUserApplications()
        await self.loadUserEducation()
        await self.loadUserJobs()
        await self.loadUserSkills()
        
        DispatchQueue.main.async {
            self.getUserProfilePicture()
            completion()
        }
    }
    
    public func getUserId() -> String {
        return self.userId
    }
    
    public func getUsername() -> String {
        return self.username
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
            let profile = try await Amplify.DataStore.query(Profile.self, where: Profile.keys.userID == self.userId)
            
            DispatchQueue.main.async {
                if !profile.isEmpty {
                        self.profile = profile[0]
                } else {
                    var profile = UserManager.defaultProfile
                    profile.userID = self.userId
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
    
    /**
     Upload the profile picture to the cloud
     */
    public func uploadProfilePicture(image: UIImage) async {
        do {
            print("Uploading profile picture")
            // Create image ID and get the image data
            let imageName = UUID().uuidString + ".jpeg"
            let imageData = image.jpegData(compressionQuality: 0.6)
            
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
    
    public func getUserProfilePicture() {
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
    
    /// Load all the user's education records.
    public func loadUserEducation() async {
        do {
            // Query the DataStore
            let educationRecords = try await Amplify.DataStore.query(Education.self, where: Education.keys.userID == self.userId)
            
            educationRecords.forEach { education in
                Task {
                    await self.loadEducationCourses(educationID: education.id)
                }
            }
            
            DispatchQueue.main.async {
                self.education = educationRecords
                print("User education loaded")
            }
        } catch let error as DataStoreError {
            print("Error fetching user education. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    public func lazyCoursesForEducation(educationId: String) -> [Course] {
        return self.courses[educationId] ?? []
    }
    
    public func saveCourse(course: Course) async {
        // Update locally
        DispatchQueue.main.async {
            if self.courses.keys.contains(course.educationID) {
                self.courses[course.educationID]?.append(course)
            } else {
                self.courses[course.educationID] = [course]
            }
        }
        // Update on cloud
        do {
            try await Amplify.DataStore.save(course)
        } catch let error as DataStoreError {
            print("Error saving course. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    public func loadEducationCourses(educationID: String) async {
        do {
            // Query the DataStore
            let courses = try await Amplify.DataStore.query(Course.self, where: Course.keys.educationID == educationID)
            
            DispatchQueue.main.async {
                self.courses[educationID] = courses
                print("User education loaded")
            }
        } catch let error as DataStoreError {
            print("Error fetching user jobs. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    public func removeCourse(course: Course) async {
        // Remove course from local storage
        DispatchQueue.main.async {
            self.courses[course.educationID]?.removeAll(where: {$0.id == course.id})
        }
        
        // Remove course from cloud
        do {
            try await Amplify.DataStore.delete(Course.self, where: Course.keys.id == course.id)
        } catch let error as DataStoreError {
            print("Error deleting course from DataStore. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    public func loadUserJobs() async {
        do {
            // Query the DataStore
            let jobs = try await Amplify.DataStore.query(Job.self, where: Job.keys.userID == self.userId)
            
            DispatchQueue.main.async {
                self.jobs = jobs
                print("User education loaded")
            }
        } catch let error as DataStoreError {
            print("Error fetching user jobs. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    public func saveEducation(id: String = UUID().uuidString, companyName: String, courseName: String, startDate: Date, endDate: Date) async {
        let company = Company(name: companyName, website: "", email: "", phone: "")
        let companyID = await GlobalDataManager.saveOrFetchCompany(company: company)
        
        let start = Temporal.Date(startDate)
        let end = Temporal.Date(endDate)
        
        let education = Education(id: id, userID: getUserId(), companyID: companyID, startDate: start, endDate: end, roleName: courseName)
        
        DispatchQueue.main.async {
            self.education.append(education)
        }
        
        do {
            try await Amplify.DataStore.save(education)
        } catch let error as DataStoreError {
            print("Error saving education. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    public func deleteEducation(education: Education) async {
        // Delete locally
        DispatchQueue.main.async {
            self.education.removeAll(where: {$0.id == education.id})
        }
        
        // Delete from cloud and DataStore
        do {
            try await Amplify.DataStore.delete(Education.self, where: Education.keys.id == education.id)
        } catch let error as DataStoreError {
            print("Error deleting education from DataStore. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    public func saveJob(companyName: String, jobTitle: String, description: String, startDate: Date, endDate: Date?) async {
        let company = Company(name: companyName, website: "", email: "", phone: "")
        let companyID = await GlobalDataManager.saveOrFetchCompany(company: company)
        
        let start = Temporal.Date(startDate)
        let end = endDate != nil ? Temporal.Date(endDate!) : nil
        
        let job = Job(userID: getUserId(), companyID: companyID, jobTitle: jobTitle, jobDescription: description, endDate: end, startDate: start)
        
        DispatchQueue.main.async {
            self.jobs.append(job)
        }
        
        do {
            try await Amplify.DataStore.save(job)
        } catch let error as DataStoreError {
            print("Error saving education. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    public func deleteJob(job: Job) async {
        // Delete locally
        DispatchQueue.main.async {
            self.jobs.removeAll(where: {$0.id == job.id})
        }
        
        // Delete from cloud and DataStore
        do {
            try await Amplify.DataStore.delete(Job.self, where: Job.keys.id == job.id)
        } catch let error as DataStoreError {
            print("Error deleting education from DataStore. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    public func loadUserSkills() async {
        do {
            // Query the DataStore for all skill IDs the user has
            let skills = try await Amplify.DataStore.query(UserSkills.self, where: UserSkills.keys.userID == self.userId)
            var skillNames: [String] = []
            for skill in skills {
                let skillName = await GlobalDataManager.fetchSkillName(id: skill.skillID)
                if skillName != nil {
                    skillNames.append(skillName!)
                }
            }
            let result = skillNames
            DispatchQueue.main.async {
                self.skills = result
                print("User education loaded")
            }
        } catch let error as DataStoreError {
            print("Error fetching user skills. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    public func hasSkill(skillID: String) async -> Bool {
        do {
            let skills = try await Amplify.DataStore.query(UserSkills.self, where: UserSkills.keys.userID == self.userId && UserSkills.keys.skillID == skillID)
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
    
    public func addUserSkill(skillName: String) async {
        do {
            let skillID = await GlobalDataManager.fetchOrSaveSkill(name: skillName)
            
            if skillID == nil {
                return
            }
            print("Saving skill: \(skillID!)")
            
            if await hasSkill(skillID: skillID!) {
                print("User already has skill")
                return
            }
            
            // Update the DataStore
            let userSkill = UserSkills(userID: self.userId, skillID: skillID!)
            try await Amplify.DataStore.save(userSkill)
            
            // Update local list
            DispatchQueue.main.async {
                self.skills.append(skillName)
            }
        } catch let error as DataStoreError {
            print("Error adding skill. \(error)")
        } catch {
            print("Unexpected error. \(error)")
        }
    }
    
    public func removeUserSkill(skillName: String) async {
        let skillID = await GlobalDataManager.fetchOrSaveSkill(name: skillName)
        
        // Remove locally
        DispatchQueue.main.async {
            self.skills.removeAll(where: {
                $0.lowercased() == skillName.lowercased()
            })
        }

        // Remove from DataStore.
        do {
            try await Amplify.DataStore.delete(UserSkills.self, where: UserSkills.keys.userID == self.userId && UserSkills.keys.skillID == skillID)
        } catch let error as DataStoreError {
            print("Error removing skill. \(error)")
        } catch {
            print("Unexpected error. \(error)")
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
            let settings = try await Amplify.DataStore.query(UserSettings.self, where: UserSettings.keys.userID == self.userId)

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
            let applications = try await Amplify.DataStore.query(Application.self, where: Application.keys.userID == self.userId, sort: .ascending(Application.keys.currentStage))
            
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
    public func saveOrUpdateApplication(application: Application, company: Company?) async {
        var application = application
        if let company = company {
            // Get the required company ID, whether that's one that's already saved to the cloud, or a new company ID.
            let companyID = await GlobalDataManager.saveOrFetchCompany(company: company)
            
            // Update the application's company ID
            application.companyID = companyID
        }
        
        let updatedApplication = application
        
        // Check if the application already exists (for analytics)
        let exists = self.applications.first(where: {$0.id == updatedApplication.id}) != nil
        if exists {
            AnalyticsManager.logUpdateApplicationEvent(applicationId: updatedApplication.id, newStage: updatedApplication.currentStage!)
        } else {
            AnalyticsManager.logNewApplicationEvent(jobTitle: application.jobTitle!, companyName: company!.name)
        }
        
        // Update the local list of applications
        DispatchQueue.main.async {
            self.applications.removeAll(where: {$0.id == updatedApplication.id})
            self.applications.append(updatedApplication)
            self.applications.sort(by: {$0.currentStage! < $1.currentStage!})
            self.numApplications = self.applications.count
            self.streak = self.calculateStreak(applications: self.applications)
        }
        
        // Update the application on the cloud
        do {
            try await Amplify.DataStore.save(updatedApplication)
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
        DispatchQueue.main.async {
            // Delete the application from the local list of applications
            self.applications.removeAll(where: {$0.id == application.id})
        }
        
        
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
        var lastDate = Date()
        for application in applications {
            if lastDate == application.dateApplied!.foundationDate {
                continue
            }
            lastDate = application.dateApplied!.foundationDate
            // Calculate days between the application date and the current date
            let daysSince = Calendar.current.daysSince(date: application.dateApplied!.foundationDate)
            // If there is a missed day, break out of the loop
            if daysSince - streak > 1 {
                break
            }
            streak += 1
        }
        return streak
    }
    
}
