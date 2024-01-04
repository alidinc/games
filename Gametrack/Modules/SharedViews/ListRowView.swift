//
//  ListRowView.swift
//  Cards
//
//  Created by Ali Dinç on 19/12/2023.
//

import Connectivity
import SwiftUI
import Combine

enum NetworkReference {
    case network
    case local
}

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

