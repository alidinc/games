//
//  OnboardingView.swift
//  GameLob
//
//  Created by alidinc on 16/01/2024.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @AppStorage("appTint") var appTint: Color = .white
    @AppStorage("selectedIcon") private var selectedAppIcon: DeviceAppIcon = .system
    
    var body: some View {
        if isFirstTime {
            IntroView
        } else {
            ContentView()
        }
    }
    
    private var IntroView: some View {
        VStack(spacing: 15) {
            
            Image(selectedAppIcon.title.lowercased())
                .resizable()
                .frame(width: 70, height: 70)
                .scaledToFit()
                .padding(.top, 50)
                .hSpacing(.leading)
            
            Text("Spellen: \nYour iOS hub for organising and saving games in personalised libraries.")
                .font(.title.bold())
                .multilineTextAlignment(.leading)
                .padding(.top, 20)
                .padding(.bottom, 35)
            
            /// Points view
            VStack(alignment: .leading, spacing: 25) {
                PointView(
                    symbol: "info",
                    title: "Information",
                    subtitle: "Effortlessly curate and access your gaming collection."
                )
                
                PointView(
                    symbol: "list.bullet",
                    title: "Visually stunning",
                    subtitle: "Say goodbye to scattered game lists."
                )
                
                PointView(
                    symbol: "magnifyingglass",
                    title: "Advance Filters",
                    subtitle: "Find the games you want by advance search and filtering."
                )
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            .padding(.horizontal, 15)
            
            Spacer(minLength: 10)
            
            Button(action: {
                isFirstTime = false
            }, label: {
                Text("Get Started")
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(appTint.gradient, in: .rect(cornerRadius: 12))
                    .contentShape(.rect)
            })
        }
        .padding(15)
        .background(Color.black.gradient)
    }
    
    /// Point view
    @ViewBuilder
    func PointView(symbol: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 20) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(appTint.gradient)
                .frame(width: 45)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .foregroundStyle(.gray)
            }
        }
    }
}
