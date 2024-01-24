//
//  AddLibraryButton.swift
//  Speeltuin
//
//  Created by Ali Dinç on 11/01/2024.
//

import SwiftData
import SwiftUI

struct LibraryView: View {
    
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("appTint") var appTint: Color = .white
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
   
    @Environment(GamesViewModel.self) private var gamesVM: GamesViewModel
    
    @State private var showAddLibrary = false
    
    @Query var savedGames: [SavedGame]
    @Query var libraries: [Library]
    
    var body: some View {
        NavigationStack {
            VStack {
                Header
                TotalGames
                AllLibrariesView()
            }
            .overlay(content: {
                if libraries.isEmpty {
                    ContentUnavailableView("No libraries found.",
                                           systemImage: "externaldrive.fill.badge.exclamationmark")
                }
            })
            .sensoryFeedback(.impact(flexibility: .solid, intensity: 0.5), trigger: hapticsEnabled && showAddLibrary)
            .sheet(isPresented: $showAddLibrary, content: {
                AddLibraryView()
                    .presentationDetents([.fraction(0.7)])
            })
        }
    }
    
    private var TotalGames: some View {
        Button {
            gamesVM.headerTitle = "All games"
            gamesVM.headerImageName =  "bookmark"
            gamesVM.searchPlaceholder = "Search in library"
            gamesVM.dataType = .library
            gamesVM.filterType = .library
    
            gamesVM.filterSegment(savedGames: savedGames)
        } label: {
            HStack {
                Text("All")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("\(savedGames.count) games")
                    .font(.subheadline.bold())
                    .foregroundStyle(.secondary)
            }
            .padding(10)
            .background(.black.opacity(0.25), in: .rect(cornerRadius: 10))
            .padding(.horizontal, 20)
        }
    }
    
    private var Header: some View {
        HStack {
            VStack {
                Text("Libraries")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .hSpacing(.leading)
                
                Text("Tap to view a library or swipe for more.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .hSpacing(.leading)
            }
            
            Button {
                showAddLibrary = true
            } label: {
                Circle()
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 30, height: 30)
                    .overlay {
                        SFImage(name: "plus", config: .init(opacity: 0, color: .secondary))
                    }
            }
            
            CloseButton()
        }
        .padding(20)
    }
}
