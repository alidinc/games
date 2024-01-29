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
    @AppStorage("appTint") var appTint: Color = .blue
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(GamesViewModel.self) private var gamesVM: GamesViewModel
    
    @State private var showAddLibrary = false
    @Query var savedGames: [SPGame]
    @Query var libraries: [SPLibrary]
    
    let dataManager: SPDataManager
    
    var body: some View {
        NavigationStack {
            VStack {
                Header
                AllLibrariesView()
            }
            .overlay(content: {
                if libraries.isEmpty {
                    ContentUnavailableView("No libraries found.",
                                           systemImage: "externaldrive.fill.badge.exclamationmark")
                }
            })
            .sheet(isPresented: $showAddLibrary, content: {
                AddLibraryView(dataManager: dataManager)
                    .presentationDetents([.medium, .large])
            })
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
                dismiss()
                
                if hapticsEnabled {
                    HapticsManager.shared.vibrateForSelection()
                }
                
                Task {
                    do {
                        try await Task.sleep(seconds: 0.05)
                        
                        NotificationCenter.default.post(name: .newLibraryButtonTapped, object: nil)
                    } catch {
                        
                    }
                }
                
            } label: {
                Circle()
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 30, height: 30)
                    .overlay {
                        Image(systemName: "plus")
                            .foregroundStyle(.gray)
                    }
            }
            
            CloseButton()
        }
        .padding(20)
    }
}
