//
//  HeaderView.swift
//  JustGames
//
//  Created by Ali Dinç on 19/12/2023.
//

import SwiftData
import SwiftUI

struct SelectedOptionsTitleView: View {
    
    var reference: DataType
    @Binding var selectedSegment: SegmentType
    @AppStorage("appTint") var appTint: Color = .white
    
    var onTap: () -> Void

    @Environment(GamesViewModel.self) private var vm

    var platforms: String {
        return vm.fetchTaskToken.platforms.isEmpty ? "Platforms" : "\(vm.fetchTaskToken.platforms.map({$0.title}).joined(separator: ", "))"
    }
    
    var genres: String {
        return vm.fetchTaskToken.genres.isEmpty ? "Genres" : "\(vm.fetchTaskToken.genres.map({$0.title}).joined(separator: ", "))"
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
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
    }
}
