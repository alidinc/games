//
//  HeaderView.swift
//  Cards
//
//  Created by Ali Dinç on 19/12/2023.
//

import SwiftData
import SwiftUI

enum SegmentType: String, CaseIterable, Identifiable {
    case category
    case platform
    case genre
    
    var id: String {
        switch self {
        default:
            UUID().uuidString
        }
    }
}

enum ViewReference {
    case network
    case local
}

struct SelectedOptionsTitleView: View {
    
    var reference: ViewReference
    @Binding var selectedSegment: SegmentType
    
    var onTap: () -> Void

    @Environment(DiscoverViewModel.self) private var discoverVM
    @Environment(LibraryViewModel.self) private var libraryVM
   
    
    @Query private var savedGames: [SavedGame]
    @State private var showSelection = false

    var platforms: String {
        switch reference {
        case .network:
            return discoverVM.fetchTaskToken.platforms.isEmpty ? "Platforms" : "\(discoverVM.fetchTaskToken.platforms.map({$0.title}).joined(separator: ", "))"
        case .local:
            return libraryVM.selectedPlatforms.isEmpty ? "Platforms" : libraryVM.selectedPlatforms.compactMap({$0.title}).joined(separator: ", ")
        }
    }
    
    var genres: String {
        switch reference {
        case .network:
            return discoverVM.fetchTaskToken.genres.isEmpty ? "Genres" : "\(discoverVM.fetchTaskToken.genres.map({$0.title}).joined(separator: ", "))"
        case .local:
            return libraryVM.selectedGenres.isEmpty ? "Genres" : libraryVM.selectedGenres.compactMap({$0.title}).joined(separator: ", ")
        }
    }
    
    var body: some View {
        HStack {
            Button {
                selectedSegment = .platform
                onTap()
            } label: {
                Text(platforms)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .underline()
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            
            Text(", ")
                .font(.subheadline)
                .foregroundStyle(.primary)
            
            Button {
                selectedSegment = .genre
                onTap()
            } label: {
                Text(genres)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .underline()
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
        }
        .hSpacing(.leading)
        .padding(.bottom, 10)
    }
}
