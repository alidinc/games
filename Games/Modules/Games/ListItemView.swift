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
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }

                    Text(game.availablePlatforms)
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Spacer()
                }

                Spacer()

                VStack {
                    RatingView(game: game)

                    Spacer()

                    Menu {
                        ForEach(libraries) { library in
                            Button {
                                if let savedGame = dataManager.add(game: game, for: library) {
                                    context.insert(savedGame)
                                }

                            } label: {
                                Text(library.title)
                            }
                        }

                        Button {

                        } label: {

                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                .padding(.top, 4)
            }
            .padding(8)
            .frame(width: UIScreen.main.bounds.size.width - 20)
            .glass()
        }
    }
    
    private func RatingView(game: Game) -> some View {
        Image(systemName: ratingImageName(game: game))
            .resizable()
            .frame(width: 16, height: 16)
            .foregroundStyle(ratingColor(game: game))
    }
    
    func ratingText(game: Game) -> String {
        guard let rating = game.totalRating else {
            return Rating.NotReviewed.rawValue
        }
        
        switch Int(rating) {
        case 0...40:
            return Rating.Skip.rawValue
        case 40...50:
            return Rating.Meh.rawValue
        case 50...80:
            return Rating.Good.rawValue
        case 80...100:
            return Rating.Exceptional.rawValue
        default:
            return Rating.NotReviewed.rawValue
        }
    }
    
    func ratingColor(game: Game) -> Color {
        guard let rating = game.totalRating else {
            return Color.gray
        }
        switch Int(rating) {
        case 0...40:
            return Color.red
        case 40...50:
            return Color.orange
        case 50...80:
            return Color.blue
        case 80...100:
            return Color.green
        default:
            return Color.gray
        }
    }
    
    func ratingImageName(game: Game) -> String {
        guard let rating = game.totalRating else {
            return "dot.squareshape.fill"
        }
        switch Int(rating) {
        case 0...40:
            return  "arrowtriangle.down.square.fill"
        case 40...50:
            return  "minus.square.fill"
        case 50...80:
            return  "arrowtriangle.up.square"
        case 80...100:
            return  "star.circle.fill"
        default:
            return "dot.squareshape.fill"
        }
    }
}

