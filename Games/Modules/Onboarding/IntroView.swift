//
//  IntroView.swift
//  Speeltuin
//
//  Created by alidinc on 22/01/2024.
//

enum OnboardingStep: String, Identifiable {
    case welcome

    var id: Self { self }
}

import SwiftUI

struct IntroView: View {

    @AppStorage("appTint") var appTint: Color = .blue

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dismiss) private var dismiss
    @Environment(SessionManager.self) private var session

    @State private var showSheet1 = true
    @State private var step: OnboardingStep = .welcome

    var body: some View {
        TabView(selection: $step) {
            WelcomeView.tag(OnboardingStep.welcome)
        }
        .ignoresSafeArea()
        .floatingBottomSheet(isPresented: $showSheet1) {
            Button("Get Started") {
                DispatchQueue.main.async {
                    session.completeOnboarding()
                    dismiss()
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .background(appTint.gradient, in: .capsule)
            .fontWeight(.bold)
            .padding(20)
            .interactiveDismissDisabled()
            .presentationDetents([.height(250)])
        }
    }

    private var WelcomeView: some View {
        HStack(spacing: 12) {
            Image(scheme == .dark ? .icon5 : .icon1)
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(color: scheme == .dark ? .white.opacity(0.1) : .black.opacity(0.05), radius: 10)

            Text("Welcome to Games")
                .font(.system(size: 40))
        }
        .displayConfetti(isActive: .constant(true))
    }
}
