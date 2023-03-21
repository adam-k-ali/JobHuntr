//
//  ModelExtensions.swift
//  JobHuntr
//
//  Created by Adam Ali on 02/03/2023.
//

import Foundation
import SwiftUI

/**
 Make the Application model conform to Identifiable
 */
extension Application: Identifiable {
}

/**
 Make the Education model conform to Identifiable
 */
extension Education: Identifiable {
}

/**
 Make the Job model conform to Identifiable
 */
extension Job: Identifiable {
}

extension UserSettings {
    var defaults: UserSettings { return UserSettings(userID: "", colorBlind: false) }
}

extension ApplicationStage: Comparable {
    public static func < (lhs: ApplicationStage, rhs: ApplicationStage) -> Bool {
        return lhs.intValue < rhs.intValue
    }
    
    var intValue: Int {
        switch self {
        case .applied:
            return 0
        case .preInterview:
            return 1
        case .interviewing:
            return 2
        case .offer:
            return 3
        case .rejection:
            return 4
        case .accepted:
            return 5
        }
    }
    
    var color: Color {
        switch self {
            case .applied:
            return Color(hex: "#ef9b20")
            case .preInterview:
            return Color(hex: "#f46a9b")
            case .interviewing:
            return Color(hex: "#27aeef")
            case .offer:
            return Color(hex: "#f46a9b")
            case .rejection:
            return Color(hex: "#ea5545")
            case .accepted:
            return Color(hex: "#87bc45")
        }
    }
    var name: String {
        switch self {
            case .applied:
                return "Applied"
            case .preInterview:
                return "Pre-Interview"
            case .interviewing:
                return "Interviewing"
            case .offer:
                return "Offer Received"
            case .rejection:
                return "Rejected"
            case .accepted:
                return "Offer Accepted"
        }
    }
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            return (red, green, blue, alpha)
        }
}

extension Color {
    init(uiColor: UIColor) {
            self.init(red: Double(uiColor.rgba.red),
                      green: Double(uiColor.rgba.green),
                      blue: Double(uiColor.rgba.blue),
                      opacity: Double(uiColor.rgba.alpha))
        }
    
    init(hex: String) {
            let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int: UInt64 = 0
            Scanner(string: hex).scanHexInt64(&int)
            let a, r, g, b: UInt64
            switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
            }

            self.init(
                .sRGB,
                red: Double(r) / 255,
                green: Double(g) / 255,
                blue:  Double(b) / 255,
                opacity: Double(a) / 255
            )
        }
}

struct AppColors {
    public static var background: Color = Color("AppBackground")
    public static var secondary: Color = Color("Secondary")
    public static var primary: Color = Color("Primary")
    public static var fontColor: Color = Color.white.opacity(0.9)
}

extension Date {
    func now() -> Date {
        return Date()
    }
    
    func format(date: DateFormatter.Style, time: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = date
        dateFormatter.timeStyle = time
        
        return dateFormatter.string(from: self)
    }
    
    func format(formatString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.string(from: self)
    }
}

extension Calendar {
    public func daysSince(date: Date) -> Int {
        return self.dateComponents([.day], from: date, to: Date()).day!
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
