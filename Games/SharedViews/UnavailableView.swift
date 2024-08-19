//
//  UnavailableView.swift
//  Games
//
//  Created by Ali Dinç on 18/08/2024.
//

import SwiftUI

struct UnavailableView: View {

    @AppStorage("appTint") var appTint: Color = .blue
    @AppStorage("hapticsEnabled") var hapticsEnabled = true

    let message: String
    let imageName: String
    let action: (() -> Void)?

    init(_ message: String, systemImage: String, action: (() -> Void)? = nil) {
        self.message = message
        self.imageName = systemImage
        self.action = action
    }

    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .padding(.bottom, 8)

            Text(message)
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if let action {
                Button("Reset filters") {
                    if hapticsEnabled { HapticsManager.shared.vibrateForSelection() }
                    action()
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .foregroundStyle(.white)
                .background(appTint, in: .capsule)
            }
        }
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
