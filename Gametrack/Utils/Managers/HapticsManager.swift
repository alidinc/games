//
//  HapticsManager.swift
//  Gameraw
//
//  Created by Ali Dinç on 29/11/2022.
//


import CoreHaptics
import UIKit

final class HapticsManager {
    static let shared = HapticsManager()
    
    private init() { }
    
    // MARK: - Public
    public func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    // Vibrate for type
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
