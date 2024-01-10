//
//  CustomSegmentedView.swift
//  JustGames
//
//  Created by Ali Dinç on 20/12/2023.
//

import SwiftUI

enum SegmentType: String, CaseIterable, Identifiable {
    case platform
    case genre
    
    var id: String {
        switch self {
        default:
            UUID().uuidString
        }
    }
}

struct SelectionsView: View {
    
    @AppStorage("appTint") var appTint: Color = .white
    @Binding var reference: DataType
    @Binding var selectedSegment: SegmentType
    @Environment(GamesViewModel.self) private var vm
    @Namespace private var animation
    
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
            
            SegmentedView(selectedSegment: $selectedSegment,
                          segments: SegmentType.allCases,
                          segmentContent: { item in
                Text(item.rawValue.capitalized)
            })
            
            OptionsView
        }
        .background(Color.black.opacity(0.25))
    }
    
    private var OptionsView: some View {
        VStack {
            switch selectedSegment {
            case .platform:
                PlatformsView()
            case .genre:
                GenresView()
            }
        }
    }
    
    private func PlatformsView() -> some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                
                               ]) {
                switch reference {
                default:
                    ForEach(PopularPlatform.allCases.sorted(by: { $0.title < $1.title })) { platform in
                        Button {
                            if vm.fetchTaskToken.platforms.contains(platform) {
                                if let index = vm.fetchTaskToken.platforms.firstIndex(of: platform) {
                                    vm.fetchTaskToken.platforms.remove(at: index)
                                }
                            } else {
                                vm.fetchTaskToken.platforms.removeAll(where: { $0.id == PopularPlatform.database.id })
                                vm.fetchTaskToken.platforms.append(platform)
                            }
                        } label: {
                            OptionTileView(imageName: platform.assetName,
                                           title: platform.title,
                                           isSelected: vm.fetchTaskToken.platforms.contains(platform))
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private func GenresView() -> some View {
        ScrollView {
            LazyVGrid(columns: [ GridItem(.flexible()),
                                 GridItem(.flexible()),
                                 GridItem(.flexible()),
                                 GridItem(.flexible()),
                               ]) {
                switch reference {
                default:
                    ForEach(PopularGenre.allCases.sorted(by: { $0.title < $1.title })) { genre in
                        Button {
                            if vm.fetchTaskToken.genres.contains(genre) {
                                if let index = vm.fetchTaskToken.genres.firstIndex(of: genre) {
                                    vm.fetchTaskToken.genres.remove(at: index)
                                }
                            } else {
                                vm.fetchTaskToken.genres.removeAll(where: { $0.id == PopularGenre.allGenres.id })
                                vm.fetchTaskToken.genres.append(genre)
                            }
                        } label: {
                            OptionTileView(imageName: genre.assetName,
                                           title: genre.title,
                                           isSelected: vm.fetchTaskToken.genres.contains(genre))
                        }
                    }
                }
            }
            .padding()
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
