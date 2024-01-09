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
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    MoreHeaderTextView(title: "About", subtitle: "Just about \(Bundle.main.appName)")
                    Spacer()
                    CloseButton { self.dismiss() }
                }
                
                VStack(alignment: .center) {
                    CreditsButton
                    TeamButton
                    Spacer(minLength: 100)
                    MadeWithLoveView()
                }
            }
            .padding()
            .background(Color.black.opacity(0.25))
            .edgesIgnoringSafeArea(.all)
        }
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
            ScrollView {
                VStack(alignment: .center) {
                    CreditsView
                    Spacer()
                }
            }
            .navigationTitle("Credits")
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
        .padding(16)
        .hSpacing(.leading)
        .frame(height: 80)
        .background(Color.gray.opacity(0.15), in: .rect(cornerRadius: 10))
    }
    
    private var TeamView: some View {
        ScrollView {
            MoreHeaderTextView(title: "Team", subtitle: "")
            VStack(alignment: .leading) {
                TeamMemberView(with: Constants.URLs.LinkedIn(profile: "ali-dinc/"), name: "Ali Dinç", subtitle: "Developer")
                TeamMemberView(with: Constants.URLs.LinkedIn(profile: "erwinbaragula/"), name: "Erwin Baragula", subtitle: "UX Consultant")
            }
        }
        .padding()
        .background(Color.black.opacity(0.25))
        .edgesIgnoringSafeArea(.all)
    }
    
    private var CreditsView: some View {
        VStack(alignment: .leading) {
            Link(destination: Constants.URLs.IGDB) { CreditPlatformView(text: "Game data by", logoName: "IGDB") }
            
            Link(destination: Constants.URLs.IGN) { CreditPlatformView(text: "IGN articles by", logoName: "IGN")  }
            
            Link(destination: Constants.URLs.NintendoLife) { CreditPlatformView(text: "Nintendo articles by", logoName: "nintendoLife")  }
            
            Link(destination: Constants.URLs.PureXbox) { CreditPlatformView(text: "Xbox articles by", logoName: "pureXbox")  }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
