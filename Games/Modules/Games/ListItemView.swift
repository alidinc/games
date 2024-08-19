//
//  ListRowView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 19/12/2023.
//

import Connectivity
import SwiftUI
import SwiftData
import Combine

enum NetworkStatus {
    case available
    case unavailable
}

struct ListItemView: View {

    var game: Game?
    @Binding var showAddLibrary: Bool

    @AppStorage("appTint") var appTint: Color = .blue

    @State var vm = GameDetailViewModel()

    @Environment(DataManager.self) private var dataManager
    @Environment(Admin.self) private var admin
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var context

    @Query var libraries: [Library]

    var body: some View {
        if let game {
            HStack(alignment: .top, spacing: 10) {
                if let cover = game.cover, let url = cover.url {
                    AsyncImageView(with: url, type: .list)
                }

                VStack(alignment: .leading, spacing: 6) {
                    if let name = game.name {
                        Text(name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }

                    Text(game.availablePlatforms)
                        .foregroundStyle(.secondary)
                        .font(.caption)

                    Spacer()
                }
                .multilineTextAlignment(.leading)

                Spacer()

                VStack {
                    ListItemRatingView(game: game)

                    Spacer()

                    SavingMenu(game: game, showAddLibrary: $showAddLibrary)
                }
                .padding(.top, 4)
            }
            .padding(8)
            .frame(width: UIScreen.main.bounds.size.width - 20)
            .glass()
        }
    }
}
