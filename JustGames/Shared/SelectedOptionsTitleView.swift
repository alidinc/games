//
//  HeaderView.swift
//  JustGames
//
//  Created by Ali Dinç on 19/12/2023.
//

import SwiftData
import SwiftUI

struct SelectedOptionsTitleView: View {
    
    @Binding var reference: DataType
    @Binding var selectedSegment: SegmentType
    @AppStorage("appTint") var appTint: Color = .white
    
    var onTap: () -> Void

    @Binding var vm: GamesViewModel
    @Query private var data: [SavedGame]

    var platforms: String {
        switch reference {
        case .network:
            return vm.fetchTaskToken.platforms.isEmpty ? "Platforms" : "\(vm.fetchTaskToken.platforms.map({$0.title}).joined(separator: ", "))"
        case .library:
            return vm.selectedPlatforms.isEmpty ? "Platforms" : "\(vm.selectedPlatforms.map({$0.title}).joined(separator: ", "))"
        }
    }
    
    var genres: String {
        switch reference {
        case .network:
            return vm.fetchTaskToken.genres.isEmpty ? "Genres" : "\(vm.fetchTaskToken.genres.map({$0.title}).joined(separator: ", "))"
        case .library:
            return vm.selectedGenres.isEmpty ? "Genres" : "\(vm.selectedGenres.map({$0.title}).joined(separator: ", "))"
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
            
            Spacer()
            
            ClearButton
                .padding(.top)
                .padding(.vertical)
                .padding(.leading)
                
        }
        .hSpacing(.leading)
        .vSpacing(.bottom)
        .padding(.vertical, 10)
    }
    
    @ViewBuilder
    private var ClearButton: some View {
        switch reference {
        case .network:
            if vm.showDiscoverClearButton {
                Button(action: {
                    vm.fetchTaskToken.platforms = [.database]
                    vm.fetchTaskToken.genres = [.allGenres]
                    
                    Task {
                        await vm.refreshTask()
                    }
                }, label: {
                    ClearButtonView
                })
            }
        case .library:
            if vm.showLibraryClearButton {
                Button(action: {
                    vm.selectedGenres = []
                    vm.selectedPlatforms = []
                    vm.filterSegment(games: data, for: .init(title: "All"))
                }, label: {
                    ClearButtonView
                })
            }
        }
    }
    
    private var ClearButtonView: some View {
        Label("Clear", systemImage: "xmark.circle")
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .font(.caption)
            .foregroundStyle(.white)
            .background(.secondary, in: .capsule)
    }
}
