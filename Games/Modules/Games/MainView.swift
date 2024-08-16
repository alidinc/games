//
//  GamesTab.swift
//  Speeltuin
//
//  Created by Ali Dinç on 17/12/2023.
//

import SwiftData
import SwiftUI
import Combine


enum ContentType: String, CaseIterable, Identifiable {
    case games
    case news

    var id: Self { return self }

    var title: String {
        return self.rawValue.capitalized
    }

    var imageName: String {
        switch self {
        case .games:
            return "gamecontroller.fill"
        case .news:
            return "newspaper.fill"
        }
    }
}

struct MainView: View {
    
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("viewType") var viewType: ViewType = .list
    @AppStorage("appTint") var appTint: Color = .blue
    @Query(animation: .easeInOut) var savedGames: [SPGame]
    @Query(animation: .easeInOut) var savedLibraries: [SPLibrary]

    @State var newsVM = NewsViewModel()
    @State var isTextFieldFocused: Bool = false
    @State var vm: GamesViewModel
    @State var showSearch = false
    @State var showLibraries = false
    @State var showSelectionOptions = false
    @State var gameToAddForNewLibrary: Game?
    @State var showAddLibraryWithNoGame = false

    @State var contentType: ContentType = .games

    let dataManager: DataManager
    
    var body: some View {
        NavigationStack {
            CountView
            MainStack
        }
    }
}

extension MainView {

    var CountView: some View {
        VStack(spacing: 6) {
            Text(124, format: .number)
                .font(.system(size: 80))
                .fontWeight(.semibold)
                .contentTransition(.numericText())

            Text("Played in 2024")
                .foregroundStyle(appTint)
        }
        .frame(height: UIScreen.main.bounds.height/5.5)
    }


    @ViewBuilder
    var ContentTypeView: some View {
        switch self.contentType {
        case .games:
            GamesCollectionView(dataManager: dataManager)
                .overlay { GamesOverlayView() }
                .refreshable {
                    await vm.refreshTask()
                }
        case .news:
            NewsTab(dataManager: dataManager, vm: newsVM)
        }
    }

    var MainStack: some View {
        VStack {
            Header
            ContentTypeView
        }
        .ignoresSafeArea(edges: .bottom)
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
        .onChange(of: showSearch) { oldValue, newValue in
            isTextFieldFocused = newValue
        }
        .task(id: vm.fetchTaskToken) { await vm.fetchGames() }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    MoreTab()
                } label: {
                    Image(systemName: "gearshape.fill")
                }
            }
        }
    }
}
