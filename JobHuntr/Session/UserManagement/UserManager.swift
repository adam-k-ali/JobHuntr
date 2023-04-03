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
    private var username: String = ""
    private var userId: String = ""
        
    @Published public var profile: UserProfileManager = UserProfileManager()
    @Published public var settings: UserSettingsManager = UserSettingsManager()
    @ObservedObject public var applications: UserApplicationManager = UserApplicationManager()
    @Published public var education: UserEducationManager = UserEducationManager()
    @Published public var courses: UserCourseManager = UserCourseManager()
    @Published public var jobs: UserJobManager = UserJobManager()
    @Published public var skills: UserSkillsManager = UserSkillsManager()
        
    public func load(username: String, userId: String, completion: @escaping () -> Void) {
        print("Loading user \(username)")
        self.username = username
        self.userId = userId
        if userId.isEmpty {
            return
        }
        Task {
            await self.downloadUserData()
            completion()
        }
    }
    
    private func downloadUserData() async {
        print("Downloading user data")
        await self.settings.load(userId: self.userId)
        await self.applications.load(userId: self.userId)
        await self.education.load(userId: self.userId)
        await self.courses.load(userId: self.userId)
        await self.jobs.load(userId: self.userId)
        await self.skills.load(userId: self.userId)
    }
    
    public func getUserId() -> String {
        return self.userId
    }
    
    public func getUsername() -> String {
        return self.username
    }
}
