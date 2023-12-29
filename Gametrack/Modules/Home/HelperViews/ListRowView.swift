//
//  ListRowView.swift
//  Cards
//
//  Created by Ali Dinç on 19/12/2023.
//

import SwiftUI


struct ListRowView: View {
    
    var game: Game
    
    var platformsText: String {
        guard let platforms = self.game.platforms else {
            return "N/A"
        }
        
        return platforms.compactMap({$0.name}).joined(separator: ", ")
    }

    var body: some View {
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
                
                ReleaseDateView(game: game)
                
                Text(self.platformsText)
                    .foregroundStyle(.secondary)
                    .font(.caption)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    RatingStatusView(game: game)
                    Spacer()
                }
            }
        }
        .padding(12)
        .background(.gray.opacity(0.15), in: .rect(cornerRadius: 20))
        .frame(maxHeight: .infinity)
        .shadow(radius: 4)
    }
}

struct ReleaseDateView: View {
    
    var game: Game
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let firstReleaseDate = self.game.firstReleaseDate  {
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
    }
}
