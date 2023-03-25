//
//  LaunchScreenStateManager.swift
//  JobHuntr
//
//  Created by Adam Ali on 24/03/2023.
//

import Foundation


enum LaunchState {
    case loading, finished
}

final class LaunchStateManager: ObservableObject {
    @Published private(set) var state: LaunchState = .loading
    
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
