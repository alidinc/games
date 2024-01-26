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
    @Query(animation: .easeInOut) var savedGames: [SavedGame]
    @Query(animation: .easeInOut) var savedLibraries: [Library]
   
    @State var vm: GamesViewModel
    @State var showLibraries = false
    @State var showSelectionOptions = false
    @State var gameToAddForNewLibrary: Game?
    @State var receivedLibrary: Library?
    
    var body: some View {
        NavigationStack {
            MainStack
        }
        .task(id: vm.fetchTaskToken) { await vm.fetchGames() }
        .sensoryFeedback(.impact(flexibility: .solid, intensity: 0.5),
                         trigger: hapticsEnabled && (showLibraries || showSelectionOptions))
        .sheet(isPresented: $showLibraries, content: {
            LibraryView().presentationDetents([.medium])
        })
        .sheet(item: $gameToAddForNewLibrary, content: { game in
            AddLibraryView(game: game).presentationDetents([.fraction(0.7)])
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
        .padding(.horizontal, 20)
        .background(.gray.opacity(0.15))
        .toolbarBackground(.hidden, for: .tabBar)
        .toolbarBackground(.hidden, for: .navigationBar)
        .onReceive(NotificationCenter.default.publisher(for: .newLibraryButtonTapped), perform: { notification in
            if let game = notification.object as? Game {
                gameToAddForNewLibrary = game
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: .addedToLibrary), perform: { notification in
            if let library = notification.object as? Library {
                receivedLibrary = library
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
    }
}
