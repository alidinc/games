//
//  AboutView.swift
//  Speeltuin
//
//  Created by Ali Dinc on 16/02/2023.
//

import SwiftUI

struct AboutView: View {

    @Environment(\.colorScheme) private var scheme
    @State private var showSafari = false

    var body: some View {
        VStack(spacing: 20) {
            Text("This app is for everyone. Many thanks for the games data by IGDB and the news data by; IGN, Nintendo News, and Xbox News.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TeamMemberView

            Spacer()

            Marquee(targetVelocity: 50) {
                CustomSelectionView(assetName: scheme == .dark ? "Icon5" : "Icon",
                                    title: "Games \(Bundle.main.appVersionLong)",
                                    subtitle: "Built with SwiftUI and ❤️",
                                    config: .init(titleFont: .system(size: 12),
                                                  titleFontWeight: .medium,
                                                  subtitleFont: .caption2,
                                                  subtitleFontWeight: .regular,
                                                  showChevron: false))
                .onTapGesture { showSafari = true }
            }
            .padding(.bottom, 40)
        }
        .padding()
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showSafari, content: { SFSafariView(url: URL(string: Constants.URLs.SwiftUI)!).ignoresSafeArea()  })
    }

    @ViewBuilder
    private var TeamMemberView: some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: "person.fill")
                    .imageScale(.large)

                VStack(alignment: .leading) {
                    Text("Ali Dinç")
                        .font(.headline.bold())
                        .foregroundColor(.primary)

                    Text("Developer")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()


                HStack {
                    if let url = URL(string: Constants.URLs.LinkedIn(profile: "ali-dinc/")) {
                        Link(destination: url) {
                            Image(.linkedin)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }

                    if let url = URL(string: Constants.URLs.ThreadsURL) {
                        Link(destination: url) {
                            Image(.threads)
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }

                }
                .hSpacing(.trailing)
            }
            .padding(.horizontal)

        }
        .padding(.vertical)
        .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 12))
    }
}
