//
//  IntroView.swift
//  Speeltuin
//
//  Created by alidinc on 22/01/2024.
//

import SwiftUI

struct IntroView: View {
    
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @AppStorage("appTint") var appTint: Color =  .blue

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        WelcomeView
        .safeAreaInset(edge: .bottom) {
            Button("Get Started") {
                
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .background(appTint.gradient, in: .capsule)
            .fontWeight(.bold)
            .padding(20)
            .displayConfetti(isActive: $isFirstTime)
        }
    }

    private var WelcomeView: some View {
        HStack(spacing: 12) {
            Image(scheme == .dark ? .icon5 : .icon1)
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(color: scheme == .dark ? .white.opacity(0.1) : .black.opacity(0.05), radius: 10)

            Text("Welcome to Steps")
                .font(.system(size: 40))
        }
    }
}
