//
//  ListRowView.swift
//  Cards
//
//  Created by Ali Dinç on 19/12/2023.
//

import SwiftUI


struct ListRowView: View {
    
    var game: Game
    
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
                }
                
                ReleaseDateView(game: game)
                
                Text(game.platformsText)
                    .foregroundStyle(.secondary)
                    .font(.caption)
                    .lineLimit(2)
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    RatingStatusView(game: game)
                    Spacer()
                }
            }
        }
        .padding(12)
        .background(.ultraThickMaterial)
        .cornerRadius(16)
        .frame(maxHeight: .infinity)
        .shadow(radius: 4)
    }
}

struct ReleaseDateView: View {
    
    var game: Game
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let firstReleaseDate = self.game.firstReleaseDate,
               let lastReleaseDate =  self.game.releaseDates?.compactMap({$0.date}).max()  {
                
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
                
                HStack(spacing: 2) {
                    HStack(spacing: 10) {
                        Text(self.timestampString(for: lastReleaseDate))
                            .foregroundStyle(.secondary)
                            .font(.caption2)
                        
//                        if let platformId = self.game.releaseDates?.first(where: {$0.date == lastReleaseDate})?.platform {
//                            if platformId == self.game.platforms?.first(where: {$0.platform?.id == platformId })?.id {
//                                Image(self.game.platforms?.first(where: {$0.platform?.id == platformId })?.platform?.assetName ?? "")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(maxWidth: 14)
//                            }
//                        }
                    }
                }
                .multilineTextAlignment(.leading)
            }
        }
    }
    
    func timestampString(for timeInterval: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth, .month, .year]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        
        let releaseDate = timeInterval.numberToDate()
        
        if releaseDate > Date() {
            return "Upcoming in " + formatter.string(from: Date(), to: releaseDate)!
        } else {
            return "Updated " + formatter.string(from: releaseDate, to: Date())! + " ago"
        }
    }
}
