//
//  CustomSegmentedView.swift
//  JustGames
//
//  Created by Ali Dinç on 20/12/2023.
//

import SwiftUI

struct SelectionsView:  View {
    
    var reference: ViewReference
    
    @Environment(DiscoverViewModel.self) private var discoverVM
    @Environment(LibraryViewModel.self) private var libraryVM
    
    @Binding var selectedSegment: SegmentType
    @Namespace private var animation
    
    @Environment(\.dismiss) private var dismiss
    @AppStorage("appTint") var appTint: Color = .white
    @State private var showClear = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack {
                    Text("Select your \(selectedSegment.rawValue)")
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .hSpacing(.leading)
                    
                    if selectedSegment == .platform || selectedSegment == .genre {
                        Text("You can select multiple options.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                            .hSpacing(.leading)
                    } else {
                        Text("This is a category based on the data.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                            .hSpacing(.leading)
                    }
                }
                
                CloseButton()
            }
            .padding(20)
            
            SegmentedView(selectedSegment: $selectedSegment, segments: reference == .local ? [SegmentType.platform, SegmentType.genre] : SegmentType.allCases, segmentContent: { item in
                Text(item.rawValue.capitalized)
            })
            
            switch reference {
            case .network:
                OptionsView
            case .local:
                LocalOptionsView
            }
                
        }
        .background(Color.black.opacity(0.25))
        .onChange(of: discoverVM.fetchTaskToken.platforms, { oldValue, newValue in
            Task {
                withAnimation {
                    if discoverVM.fetchTaskToken.platforms.isEmpty {
                        discoverVM.fetchTaskToken.platforms = [.database]
                    } else {
                        discoverVM.fetchTaskToken.platforms = newValue
                    }
                }
                await discoverVM.refreshTask()
            }
        })
        .onChange(of: discoverVM.fetchTaskToken.genres, { oldValue, newValue in
            Task {
                withAnimation {
                    if discoverVM.fetchTaskToken.genres.isEmpty {
                        discoverVM.fetchTaskToken.genres = [.allGenres]
                    } else {
                        discoverVM.fetchTaskToken.genres = newValue
                    }
                }
                await discoverVM.refreshTask()
            }
        })
    }
    
    private var LocalOptionsView: some View {
        VStack {
            switch selectedSegment {
            case .category:
                EmptyView()
            case .platform:
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()),
                                        GridItem(.flexible()),
                                        GridItem(.flexible()),
                                        GridItem(.flexible()),
                                       
                                       ]) {
                        ForEach(PopularPlatform.allCases.sorted(by: { $0.title < $1.title })) { platform in
                            Button {
                                if libraryVM.selectedPlatforms.contains(platform) {
                                    if let index = libraryVM.selectedPlatforms.firstIndex(of: platform) {
                                        libraryVM.selectedPlatforms.remove(at: index)
                                    }
                                } else {
                                    libraryVM.selectedPlatforms.append(platform)
                                }
                            } label: {
                                OptionTileView(imageName: platform.assetName, 
                                               title: platform.title,
                                               isSelected: libraryVM.selectedPlatforms.contains(platform))
                            }
                        }
                    }
                    .padding()
                }
            case .genre:
                ScrollView {
                    LazyVGrid(columns: [ GridItem(.flexible()),
                                          GridItem(.flexible()),
                                          GridItem(.flexible()),
                                          GridItem(.flexible()),
                                       ]) {
                        ForEach(PopularGenre.allCases.sorted(by: { $0.title < $1.title })) { genre in
                            Button {
                                if libraryVM.selectedGenres.contains(genre) {
                                    if let index = libraryVM.selectedGenres.firstIndex(of: genre) {
                                        libraryVM.selectedGenres.remove(at: index)
                                    }
                                } else {
                                    libraryVM.selectedGenres.append(genre)
                                }
                            } label: {
                                OptionTileView(
                                    imageName: genre.assetName,
                                    title: genre.title,
                                    isSelected: libraryVM.selectedGenres.contains(genre))
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    @ViewBuilder
    private var OptionsView: some View {
        switch selectedSegment {
        case .platform:
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                   
                                   ]) {
                    ForEach(PopularPlatform.allCases.filter{ $0.id != PopularPlatform.database.id }.sorted(by: { $0.title < $1.title })) { platform in
                        Button {
                            if discoverVM.fetchTaskToken.platforms.contains(platform) {
                                if let index = discoverVM.fetchTaskToken.platforms.firstIndex(of: platform) {
                                    discoverVM.fetchTaskToken.platforms.remove(at: index)
                                }
                            } else {
                                discoverVM.fetchTaskToken.platforms.removeAll(where: { $0.id == PopularPlatform.database.id })
                                discoverVM.fetchTaskToken.platforms.append(platform)
                            }
                        } label: {
                            OptionTileView(imageName: platform.assetName,
                                           title: platform.title,
                                           isSelected: discoverVM.fetchTaskToken.platforms.contains(platform))
                        }
                    }
                }
                .padding()
            }
        case .genre:
            ScrollView {
                LazyVGrid(columns: [ GridItem(.flexible()),
                                      GridItem(.flexible()),
                                      GridItem(.flexible()),
                                      GridItem(.flexible()),
                                   ]) {
                    ForEach(PopularGenre.allCases.filter { $0.id != PopularGenre.allGenres.id }.sorted(by: { $0.title < $1.title })) { genre in
                        Button {
                            if discoverVM.fetchTaskToken.genres.contains(genre) {
                                if let index = discoverVM.fetchTaskToken.genres.firstIndex(of: genre) {
                                    discoverVM.fetchTaskToken.genres.remove(at: index)
                                }
                            } else {
                                discoverVM.fetchTaskToken.genres.removeAll(where: { $0.id == PopularGenre.allGenres.id })
                                discoverVM.fetchTaskToken.genres.append(genre)
                            }
                        } label: {
                            OptionTileView(imageName: genre.assetName,
                                           title: genre.title,
                                           isSelected: discoverVM.fetchTaskToken.genres.contains(genre))
                        }
                    }
                }
                .padding()
            }
        case .category:
            ScrollView {
                LazyVStack {
                    ForEach([Category.topRated, Category.newReleases, Category.upcoming, Category.upcomingThisWeek, Category.upcomingThisMonth]) { category in
                        
                        Button {
                            if discoverVM.fetchTaskToken.category == category {
                                discoverVM.fetchTaskToken.category = .database
                            } else {
                                discoverVM.fetchTaskToken.category = category
                            }
                        } label: {
                            HStack(alignment: .center, spacing: 12) {
                                Image(systemName: category.systemImage)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.white)
                                    .frame(width: 20, height: 20)
                                
                                Text(category.title)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            .foregroundStyle(.primary)
                            .hSpacing(.leading)
                            .background(
                                Color.black.opacity(0.5), in: .rect(cornerRadius: 20)
                            )
                            .overlay {
                                if discoverVM.fetchTaskToken.category == category {
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(appTint, lineWidth: 2)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    
    private func OptionTileView(imageName: String, title: String, isSelected: Bool) -> some View {
        VStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.caption2)
                .foregroundStyle(isSelected ? .primary : .secondary)
                .multilineTextAlignment(.center)
        }
        .padding(8)
        .frame(width: 85, height: 85)
        .background(Color.black.opacity(0.5), in: .rect(cornerRadius: 10))
        .overlay {
            if isSelected {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(appTint, lineWidth: 2)
            }
        }
    }
}
