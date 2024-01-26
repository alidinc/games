//
//  ListRowView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 19/12/2023.
//

import Connectivity
import SwiftUI
import Combine

enum NetworkStatus {
    case available
    case unavailable
}

struct GameListItemView: View {
    
    var game: Game?
    var savedGame: SavedGame?
    
    @State var vm = GameDetailViewModel()
    @Environment(Admin.self) private var admin
    @Environment(\.colorScheme) var colorScheme
    
    init(game: Game? = nil, savedGame: SavedGame? = nil) {
        self.savedGame = savedGame
        self.game = game
    }
    
    var body: some View {
        switch admin.networkStatus {
        case .unavailable:
            LocalView
        case .available:
            NetworkView
        }
    }
    
    @ViewBuilder
    var LocalView: some View {
        if let savedGame {
            HStack(alignment: .top, spacing: 10) {
                if let imageData = savedGame.imageData, let uiImage = UIImage(data: imageData)  {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .shadow(color: .white.opacity(0.7), radius: 10)
                        .frame(width: 120, height: 160)
                        .clipShape(.rect(cornerRadius: 5))
                }
                
                if let game = savedGame.game {
                    VStack(alignment: .leading, spacing: 6) {
                        if let name = game.name {
                            Text(name)
                                .foregroundStyle(.primary)
                                .font(.headline)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                        
                        DatesView(game: game)
                        
                        Text(game.availablePlatforms)
                            .foregroundStyle(.secondary)
                            .font(.caption)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        HStack(alignment: .bottom) {
                            RatingView(game: game)
                            Spacer()
                            SavingButton(game: game, opacity: 0.2)
                        }
                    }
                }
            }
            .padding(12)
            .frame(width: UIScreen.main.bounds.size.width - 20)
            .background(colorScheme == .dark ? .ultraThinMaterial : .ultraThick, in: .rect(cornerRadius: 20))
            .shadow(radius: 4)
        }
    }
    
    @ViewBuilder
    var NetworkView: some View {
        if let game {
            HStack(alignment: .top, spacing: 10) {
                if let cover = game.cover, let url = cover.url {
                    AsyncImageView(with: url, type: .list)
                        .shadow(radius: 4)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    if let name = game.name {
                        Text(name)
                            .foregroundStyle(.primary)
                            .font(.headline)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    DatesView(game: game)
                    
                    Text(game.availablePlatforms)
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        RatingView(game: game)
                        Spacer()
                        SavingButton(game: game, opacity: 0.2)
                    }
                }
            }
            .padding(12)
            .frame(width: UIScreen.main.bounds.size.width - 20)
            .background(colorScheme == .dark ? .ultraThinMaterial : .ultraThick, in: .rect(cornerRadius: 20))
            .shadow(radius: 4)
        }
    }
    
    func areAllValuesSame<T: Equatable>(in array: [T]) -> Bool {
        guard let firstValue = array.first else {
            return true  // Empty array, technically all values are the same
        }
        
        return array.allSatisfy { $0 == firstValue }
    }
    
    @ViewBuilder
    private func DatesView(game: Game) -> some View {
        let now = Int(Date.now.timeIntervalSince1970)
        if let releaseDates = game.releaseDates {
            
            let dates = releaseDates.compactMap { $0.date }
            let _ = areAllValuesSame(in: dates)
            let _ = !dates.compactMap({$0 > now }).isEmpty && dates.compactMap({$0 < now}).isEmpty
            let _ = !dates.compactMap({$0 < now}).isEmpty && dates.compactMap({$0 > now}).isEmpty
            
            if let firstReleaseDate = game.firstReleaseDate {
                DateEntryView(date: firstReleaseDate.numberToDateString(), imageName: "calendar")
            }
        }
    }
    
    private func DateEntryView(date: String, imageName: String) -> some View {
        HStack {
            Image(systemName: imageName)
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
            
            Text(date)
                .foregroundStyle(.secondary)
                .font(.caption)
        }
        .hSpacing(.leading)
    }
    
    private func RatingView(game: Game) -> some View {
        HStack {
            Image(systemName: ratingImageName(game: game))
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundStyle(ratingColor(game: game))
            
            Text(ratingText(game: game))
                .font(.caption)
                .fixedSize()
                .foregroundStyle(ratingColor(game: game))
        }
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
            return  "star.square.fill"
        default:
            return "dot.squareshape.fill"
        }
    }
}

