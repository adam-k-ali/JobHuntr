//
//  LaunchScreenStateManager.swift
//  JobHuntr
//
//  Created by Adam Ali on 24/03/2023.
//

import Foundation


enum LaunchScreenState {
    case loading, finished
}

final class LaunchScreenStateManager: ObservableObject {
    @Published private(set) var state: LaunchScreenState = .loading
    
    public func isActive() -> Bool {
        return state == .loading
    }
    
    public func begin() {
        Task {
            state = .loading
        }
    }
    
    public func dismiss() {
        Task {
            state = .finished
        }
    }
}
