//
//  AboutView.swift
//  JustGames
//
//  Created by Ali Dinc on 16/02/2023.
//

import SwiftUI

struct AboutView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Header
                CreditsButton
                TeamButton
                Spacer()
            }
            .padding()
        }
    }
    
    private var Header: some View {
        HStack {
            MoreHeaderTextView(title: "About", subtitle: "You can find more about us here.")
            Spacer()
            CloseButton { self.dismiss() }
        }
        .padding(.bottom, 20)
    }
    
    private var TeamButton: some View {
        NavigationLink {
            TeamView
               
        } label: {
            MoreRowView(imageName: "person.fill", text: "Team")
                .padding(16)
                .background(Color.gray.opacity(0.15), in: .rect(cornerRadius: 10))
        }
    }
    
    private var CreditsButton: some View {
        NavigationLink {
            CreditsView
        } label: {
            MoreRowView(imageName: "network", text: "Credits")
                .padding(16)
                .background(Color.gray.opacity(0.15), in: .rect(cornerRadius: 10))
        }
    }
    
    private func CreditPlatformView(text: String, logoName: String) -> some View {
        HStack(spacing: 0) {
            Text(text)
                .font(.subheadline.bold())
                .foregroundColor(.secondary)
            
            Spacer()
            
            Image(logoName)
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .hSpacing(.trailing)
        }
        .hSpacing(.leading)
        .padding()
        .frame(height: 50)
        .background(Color.gray.opacity(0.15), in: .rect(cornerRadius: 10))
    }
    
    private var TeamView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                TeamMemberView(with: Constants.URLs.LinkedIn(profile: "ali-dinc/"), name: "Ali Dinç", subtitle: "Developer")
                TeamMemberView(with: Constants.URLs.LinkedIn(profile: "erwinbaragula/"), name: "Erwin Baragula", subtitle: "UX Consultant")
            }
            .padding()
            .navigationTitle("Credits")
        }
    }
    
    private var CreditsView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Link(destination: Constants.URLs.IGDB) { CreditPlatformView(text: "Game data", logoName: "IGDB") }
                
                Link(destination: Constants.URLs.IGN) { CreditPlatformView(text: "IGN articles", logoName: "IGN")  }
                
                Link(destination: Constants.URLs.NintendoLife) { CreditPlatformView(text: "Nintendo articles", logoName: "nintendoLife")  }
                
                Link(destination: Constants.URLs.PureXbox) { CreditPlatformView(text: "Xbox articles", logoName: "pureXbox")  }
            }
            .padding()
            .navigationTitle("Credits")
        }
    }
    
    @ViewBuilder
    private func TeamMemberView(with urlString: String, name: String, subtitle: String) -> some View {
        if let url = URL(string: urlString) {
            Link(destination: url) {
                MoreRowView(imageName: "person.fill", text: name, subtitle: subtitle)
                    .padding(16)
                    .background(Color.gray.opacity(0.15), in: .rect(cornerRadius: 10))
                    .overlay(alignment: .trailing) {
                        Image(systemName: "info")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.white)
                            .padding()
                    }
            }
        }
    }
}
