//
//  ListRowView.swift
//  JustGames
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

struct ListRowView: View {
    
    var game: Game?
    var savedGame: SavedGame?
    
    @State var vm = GameDetailViewModel()
    @Environment(Preferences.self) private var preferences
    
    init(game: Game? = nil, savedGame: SavedGame? = nil) {
        self.savedGame = savedGame
        self.game = game
    }
    
    var body: some View {
        switch preferences.networkStatus {
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
                        
                        if let firstReleaseDate = game.firstReleaseDate {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .resizable()
                                        .frame(width: 10, height: 10)
                                        .foregroundStyle(.secondary)
                                        .font(.subheadline)
                                    
                                    Text("\(firstReleaseDate.numberToDateString())")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                }
                                .hSpacing(.leading)
                            }
                        }
                        
                        if let releaseDates = game.releaseDates,
                            let lastReleasedDate = releaseDates.max(),
                            let lastDate = lastReleasedDate.date,
                            let lastPlatform = lastReleasedDate.platform,
                            Int(Date.now.timeIntervalSince1970) < lastDate {
                            
                            let lastOnePlatformName = PopularPlatform(rawValue: lastPlatform)
                            let platforms = releaseDates.filter({ Int(Date.now.timeIntervalSince1970) < $0.date ?? 0 })
                            let platformNames = platforms.compactMap({ PopularPlatform(rawValue: $0.platform ?? 0)?.title }).joined(separator: ", ")
                            
                            
                            if let lastOnePlatformName {
                                Text("Upcoming: \(lastDate.numberToDateString()) for \(lastOnePlatformName.title)")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                        }
                        
                        Text(game.availablePlatforms)
                            .foregroundStyle(.secondary)
                            .font(.caption)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        HStack(alignment: .bottom) {
                            HStack {
                                Image(systemName: game.ratingImageName)
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(game.ratingColor)
                                
                                Text(game.ratingText)
                                    .font(.caption)
                                    .fixedSize()
                                    .foregroundStyle(game.ratingColor)
                            }
                            
                            Spacer()
                            
                            
                            SavingButton(game: game, opacity: 0.2, padding: 8)
                        }
                    }
                }
            }
            .padding(12)
            .background(.gray.opacity(0.15), in: .rect(cornerRadius: 20))
            .frame(maxHeight: .infinity)
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
                    
                    if let firstReleaseDate = game.firstReleaseDate {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: "calendar")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(.secondary)
                                    .font(.subheadline)
                                
                                Text("\(firstReleaseDate.numberToDateString())")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .hSpacing(.leading)
                        }
                    }
                    
                    if let releaseDates = game.releaseDates,
                        let lastReleasedDate = releaseDates.max(),
                        let lastDate = lastReleasedDate.date,
                        let lastPlatform = lastReleasedDate.platform,
                        Int(Date.now.timeIntervalSince1970) < lastDate {
                        
                        let lastOnePlatformName = PopularPlatform(rawValue: lastPlatform)
                        let platforms = releaseDates.filter({ Int(Date.now.timeIntervalSince1970) < $0.date ?? 0 })
                        let platformNames = platforms.compactMap({ PopularPlatform(rawValue: $0.platform ?? 0)?.title }).joined(separator: ", ")
                        
                        
                        if let lastOnePlatformName {
                            Text("Upcoming: \(lastDate.numberToDateString()) for \(lastOnePlatformName.title)")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                    }
                    
                    Text(game.availablePlatforms)
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        HStack {
                            Image(systemName: game.ratingImageName)
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(game.ratingColor)
                            
                            Text(game.ratingText)
                                .font(.caption)
                                .fixedSize()
                                .foregroundStyle(game.ratingColor)
                        }
                        
                        Spacer()
                        
                        
                        SavingButton(game: game, opacity: 0.2, padding: 8)
                    }
                }
            }
            .padding(12)
            .background(.gray.opacity(0.15), in: .rect(cornerRadius: 20))
            .frame(maxHeight: .infinity)
            .shadow(radius: 4)
        }
    }
}

