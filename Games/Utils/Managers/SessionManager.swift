//
//  SessionManager.swift
//  Games
//
//  Created by Ali Dinç on 19/08/2024.
//

import SwiftUI
import WidgetKit

enum SessionState {
    case loggedIn
    case onboarding
}

@Observable
class SessionManager {

    enum UserDefaultKeys { static let hasSeenOnboarding = "hasSeenOnboarding" }
    private(set) var currentState: SessionState?

    var isConnected: Bool = false

    func completeOnboarding() {
        currentState = .loggedIn
        let defaults = UserDefaults(suiteName: "group.com.alidinc.Stap")!
        defaults.set(true, forKey: UserDefaultKeys.hasSeenOnboarding)
    }

    func configureCurrentState() {
        let defaults = UserDefaults(suiteName: "group.com.alidinc.Stap")!
        let hasCompletedOnboarding = defaults.bool(forKey: UserDefaultKeys.hasSeenOnboarding)

        if hasCompletedOnboarding {
            currentState = .loggedIn
        } else {
            currentState = hasCompletedOnboarding ? .loggedIn : .onboarding
        }

        WidgetCenter.shared.reloadAllTimelines()
    }
}
