//
//  ModelExtensions.swift
//  JobHuntr
//
//  Created by Adam Ali on 02/03/2023.
//

import Foundation
import SwiftUI

extension ApplicationStage {
    var color: Color {
        switch self {
            case .applied:
                return .yellow
            case .preInterview:
                return .blue
            case .interviewing:
                return .blue
            case .offer:
                return .yellow
            case .rejection:
                return .red
            case .accepted:
            return .green
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
