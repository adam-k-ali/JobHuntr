//
//  AnalyticsManager.swift
//  JobHuntr
//
//  Created by Adam Ali on 28/03/2023.
//

import Foundation
import Amplify

class AnalyticsManager {
    private static func logBasicEvent(name: String) {
        let event = BasicAnalyticsEvent(name: name)
        Amplify.Analytics.record(event: event)
    }
    
    public static func logAppLoad() {
        logBasicEvent(name: "app_loaded")
    }
    
    // ======================================================
    // Auth Events
    // ======================================================
    
    public static func logUserSignInEvent(user: AuthUser) {
        let userProfile = AnalyticsUserProfile(
            name: user.username,
            location: nil
        )
        
        Amplify.Analytics.identifyUser(userId: user.userId, userProfile: userProfile)
        let event = BasicAnalyticsEvent(name: "_userauth.sign_in")
        Amplify.Analytics.record(event: event)
    }
    
    public static func logUserSignUpEvent() {
        logBasicEvent(name: "_userauth.sign_out")
    }
    
    public static func logAuthFailEvent(description: String) {
        let properties: AnalyticsProperties = [
            "description": description
        ]
        let event = BasicAnalyticsEvent(name: "_userauth.auth_fail", properties: properties)
        Amplify.Analytics.record(event: event)
    }
    
    // ======================================================
    // View Events
    // ======================================================
    
    public static func logViewApplicationsEvent() {
        logBasicEvent(name: "view.view_applications")
    }
    
    public static func logViewProfileEvent() {
        logBasicEvent(name: "view.view_profile")
    }
    
    public static func logViewSettingsEvent() {
        logBasicEvent(name: "view.view_settings")
    }
    
    // ======================================================
    // Update Events
    // ======================================================
    
    public static func logNewCompanyEvent(companyName: String) {
        let properties: AnalyticsProperties = [
            "companyName": companyName
        ]
        let event = BasicAnalyticsEvent(name: "update.new_company", properties: properties)
        Amplify.Analytics.record(event: event)
        print("New company created (\(companyName))")
    }
    
    public static func logNewApplicationEvent(jobTitle: String, companyName: String) {
        let properties: AnalyticsProperties = [
            "jobTitle": jobTitle,
            "companyName": companyName
        ]
        let event = BasicAnalyticsEvent(name: "update.new_application", properties: properties)
        Amplify.Analytics.record(event: event)
        print("New application logged (\(jobTitle) at \(companyName))")
    }
    
    public static func logUpdateApplicationEvent(applicationId: String, newStage: ApplicationStage) {
        let properties: AnalyticsProperties = [
            "applicationId": applicationId,
            "newStage": newStage.name
        ]
        let event = BasicAnalyticsEvent(name: "update.update_application", properties: properties)
        Amplify.Analytics.record(event: event)
        print("Updated application \(applicationId) to \(newStage.rawValue)")
    }
    
    public static func logNewCourseEvent() {
        logBasicEvent(name: "update.new_course")
    }
    
    public static func logDataStoreError(error: DataStoreError, message: String) {
        let properties: AnalyticsProperties = [
            "message": message,
            "errorDescription": error.errorDescription,
            "debugDescription": error.debugDescription
        ]
        
        let event = BasicAnalyticsEvent(name: "error.data_store", properties: properties)
        print("============Error============")
        print(message)
        print(error.errorDescription)
        print(error.debugDescription)
        print("=============================")
        Amplify.Analytics.record(event: event)
    }
    
//    public static func logUpdateAboutMeEvent() {
//        logBasicEvent(name: "update.update_about_me")
//    }
}
