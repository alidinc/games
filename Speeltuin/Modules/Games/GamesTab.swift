//
//  GamesTab.swift
//  Speeltuin
//
//  Created by Ali Dinç on 17/12/2023.
//

import SwiftData
import SwiftUI
import Combine

struct GamesTab: View {
    
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("viewType") var viewType: ViewType = .list
    @AppStorage("appTint") var appTint: Color = .blue
    @Query(animation: .easeInOut) var savedGames: [SPGame]
    @Query(animation: .easeInOut) var savedLibraries: [SPLibrary]
   
    @State var vm: GamesViewModel
    @State var showLibraries = false
    @State var showSelectionOptions = false
    @State var gameToAddForNewLibrary: Game?
    @State var showAddLibraryWithNoGame = false

    let dataManager: DataManager
    
    var body: some View {
        NavigationStack {
            MainStack
        }
        .task(id: vm.fetchTaskToken) { await vm.fetchGames() }
        .sheet(isPresented: $showLibraries, content: {
            LibraryView(dataManager: dataManager).presentationDetents([.medium])
        })
        .sheet(isPresented: $showAddLibraryWithNoGame) {
            AddLibraryView(dataManager: dataManager).presentationDetents([.medium, .large])
        }
        .sheet(item: $gameToAddForNewLibrary, content: { game in
            AddLibraryView(game: game, dataManager: dataManager).presentationDetents([.medium, .large])
        })
        .sheet(isPresented: $showSelectionOptions, content: {
            SelectionsView().presentationDetents([.medium, .large])
        })
    }
}

extension GamesTab {
    var MainStack: some View {
        VStack {
            Header
            ViewSwitcher
        }
        .padding(.bottom, 1)
        .background(.gray.opacity(0.15))
        .toolbarBackground(.hidden, for: .tabBar)
        .toolbarBackground(.hidden, for: .navigationBar)
        .onReceive(NotificationCenter.default.publisher(for: .newLibraryButtonTapped), perform: { notification in
            if let game = notification.object as? Game {
                gameToAddForNewLibrary = game
            } else {
                withAnimation {
                    showAddLibraryWithNoGame = true
                }
            }
        })
        .onReceive(didRemoteChange, perform: { _ in
            vm.filterSegment(savedGames: savedGames)
        })
        .onChange(of: vm.fetchTaskToken.platforms, { oldValue, newValue in
            vm.onChangePlatforms(for: savedGames, newValue: newValue)
        })
        .onChange(of: vm.fetchTaskToken.genres, { oldValue, newValue in
            vm.onChangeGenres(for: savedGames, newValue: newValue)
        })
        .onChange(of: vm.searchQuery) { _, newValue in
            vm.onChangeQuery(for: savedGames, newValue: newValue)
        }
        .onChange(of: vm.selectedLibrary) { _, _ in
            if hapticsEnabled {
                HapticsManager.shared.vibrateForSelection()
            }
        }
    }
}
