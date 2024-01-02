//
//  AboutView.swift
//  GoodGames
//
//  Created by Ali Dinc on 16/02/2023.
//

import SwiftUI

struct AboutView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    MoreHeaderTextView(title: "About", subtitle: "Just about \(Bundle.main.appName)")
                    Spacer()
                    CloseButton { self.dismiss() }
                }
                
                ScrollView {
                    VStack(alignment: .center) {
                        CreditsButton
                        TeamButton
                        Spacer().frame(height: 100)
                        MadeWithLoveView()
                    }
                }
            }
            .padding()
            .background(Color.black.opacity(0.25))
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    private var IGDBView: some View {
        HStack(alignment: .center) {
            Text("Powered by")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
            
            Image("IGDB")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var TeamButton: some View {
        NavigationLink {
            TeamView
        } label: {
            MoreMainRowView(imageName: "person.fill", text: "Team")
                .padding(16)
                .background(Color.gray.opacity(0.15), in: .rect(cornerRadius: 10))
        }
    }
    
    private var CreditsButton: some View {
        NavigationLink {
            CreditsView
        } label: {
            MoreMainRowView(imageName: "network", text: "Credits")
                .padding(16)
                .background(Color.gray.opacity(0.15), in: .rect(cornerRadius: 10))
        }
    }
    
    private var CreditsView: some View {
        ScrollView {
            MoreHeaderTextView(title: "Credits", subtitle: "")
            VStack(alignment: .leading) {
                Link(destination: Constants.URLs.IGDB) { IGDBView }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
    
    private var TeamView: some View {
        ScrollView {
            MoreHeaderTextView(title: "Team", subtitle: "")
            VStack(alignment: .leading) {
                TeamMemberView(with: "https://www.linkedin.com/in/ali-dinc/", name: "Ali Dinç", subtitle: "Developer")
                TeamMemberView(with: "https://www.linkedin.com/in/brendankoeleman/", name: "Brendan Koeleman", subtitle: "Consultant")
            }
        }
        .padding()
        .background(Color.black.opacity(0.25))
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    private func TeamMemberView(with urlString: String, name: String, subtitle: String) -> some View {
        if let url = URL(string: urlString) {
            Link(destination: url) {
                MoreMainRowView(imageName: "person.fill", text: name, subtitle: subtitle)
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
