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

struct ListRowView<Content: View>: View {
    
    var imageURL: String
    var name: String
    var platforms: String
    var firstReleaseDate: Int
    var ratingImageName: String
    var ratingText: String
    var ratingColor: Color
    var ButtonContent: () -> Content
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            AsyncImageView(with: imageURL, type: .list)
                .shadow(radius: 4)
             
            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .foregroundStyle(.primary)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
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
                
                Text(platforms)
                    .foregroundStyle(.secondary)
                    .font(.caption)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    HStack {
                        Image(systemName: ratingImageName)
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(ratingColor)
                        
                        Text(ratingText)
                            .font(.caption)
                            .fixedSize()
                            .foregroundStyle(ratingColor)
                    }
                    
                    Spacer()
                    
                    ButtonContent()
                }
            }
        }
        .padding(12)
        .background(.gray.opacity(0.15), in: .rect(cornerRadius: 20))
        .frame(maxHeight: .infinity)
        .shadow(radius: 4)
    }
}

