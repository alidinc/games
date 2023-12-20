//
//  GamesView.swift
//  A-games
//
//  Created by Ali Dinç on 17/12/2023.
//

import SwiftUI


enum ViewType: String, CaseIterable {
    case list
    case grid
    case card
    
    var imageName: String {
        switch self {
        case .list:
            return "rectangle.grid.1x2.fill"
        case .grid:
            return "rectangle.grid.3x2.fill"
        case .card:
            return "list.bullet.rectangle.portrait.fill"
        }
    }
}

struct HomeView: View {
    
    @State private var vm = HomeViewModel()
    @State private var screenSize: CGSize = .zero
    @State private var hasReachedEnd = false
    @AppStorage("collectionViewType") private var viewType: ViewType = .list
    
    var bottomSheetTranslationProrated: CGFloat = 1
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    CategoryButton
                    Spacer()
                    ViewTypeButton
                }
                .padding(.top, 10)
                .padding(.horizontal)
                
                SelectionsHeaderView(vm: $vm)
            }
         
            switch viewType {
            case .list:
                ListView
                    
            case .grid:
                GridView

            case .card:
                CardsView
            }
        }
        .navigationBarHidden(true)
        .background(.gray.opacity(0.15))
        .overlay(geometryReader)
        .overlay {
            if vm.viewNotReady {
                ZStack {
                    ProgressView("Please wait, \nwhile we are getting ready! ☺️")
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .controlSize(.large)
                }
                .padding(.horizontal, 50)
                .hSpacing(.center)
                .ignoresSafeArea()
            }
        }
    }
    
    var geometryReader: some View {
        GeometryReader { proxy in
            Color.clear
                .onAppear {
                    screenSize = proxy.size
                }
                .onChange(of: proxy.size) { oldValue, newValue in
                    screenSize = newValue
                }
        }
        .task(id: vm.fetchTaskToken) {
            await vm.fetchGames()
        }
        .onChange(of: vm.fetchTaskToken.category, { oldValue, newValue in
            Task {
                await vm.refreshTask()
            }
        })
    }
    
    @MainActor
    private var ViewTypeButton: some View {
        Button {
            withAnimation(.bouncy) {
                if viewType == .list {
                    viewType = .grid
                } else if viewType == .grid {
                    viewType = .card
                } else if viewType == .card {
                    viewType = .list
                }
            }
        } label: {
            Image(systemName: viewType.imageName)
                .resizable()
                .frame(width: 24, height: 24)
                .aspectRatio(contentMode: .fit)
                .padding(10)
                .background(Color.black.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }

    }
    
    private var CategoryButton: some View {
        Menu {
            Picker("Category", selection: $vm.fetchTaskToken.category) {
                ForEach([Category.topRated,
                         Category.newReleases,
                         Category.upcoming,
                         Category.upcomingThisMonth,
                         Category.upcomingThisWeek], id: \.id) {
                    Text($0.title).tag($0)
                }
            }
        } label: {
            HStack(alignment: .center, spacing: 4) {
                Text(vm.fetchTaskToken.category.title)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(.primary)
                    .shadow(radius: 10)
                
                Image(systemName: "chevron.down")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.primary)
            }
        }
    }
    
    var GridView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(),
                                GridItem(),
                                GridItem()], spacing: 5) {
                ForEach(vm.games, id: \.id) { game in
                    if let cover = game.cover, let url = cover.url {
                        AsyncImageView(with: url, type: .grid)
                            .task {
                                if self.vm.hasReachedEnd(of: game) {
                                    await vm.fetchNextSetOfGames()
                                }
                            }
                            .task {
                                if vm.hasReachedEnd(of: game) {
                                    hasReachedEnd = true
                                }
                            }
                    }
                }
            }
            .navigationBarHidden(true)
            .scrollContentBackground(.hidden)
            .padding(.top, 10)
            .padding(.horizontal)
            .if(hasReachedEnd) { view in
                view
                    .padding(.bottom, 100)
                    .overlay(alignment: .bottom) {
                        ZStack(alignment: .center) {
                            ProgressView()
                                .controlSize(.large)
                        }
                        .hSpacing(.center)
                        .frame(height: 100)
                    }
            }
        }
    }
    
    var ListView: some View {
        ScrollView {
            LazyVStack {
                ForEach(vm.games, id: \.id) { game in
                    ListRowView(game: game)
                        .task {
                            if self.vm.hasReachedEnd(of: game) {
                                await vm.fetchNextSetOfGames()
                            }
                        }
                        .task {
                            if vm.hasReachedEnd(of: game) {
                                hasReachedEnd = true
                            }
                        }
                }
            }
            .padding(.top, 10)
            .padding(.horizontal)
            .if(hasReachedEnd) { view in
                view
                    .padding(.bottom, 100)
                    .overlay(alignment: .bottom) {
                        ZStack(alignment: .center) {
                            ProgressView()
                                .controlSize(.large)
                        }
                        .hSpacing(.center)
                        .frame(height: 100)
                    }
            }
        }
    }
    
    @ViewBuilder
    var CardsView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 50) {
                ForEach(vm.games, id: \.id) { game in
                    CardView(game: game, screenSize: $screenSize)
                        .task {
                            hasReachedEnd = vm.hasReachedEnd(of: game)
                        }
                        
                        .scrollTransition { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1 : 0.8)
                                .rotationEffect(.degrees(phase.isIdentity ? 0 : -30))
                                .rotation3DEffect(.degrees(phase.isIdentity ? 0 : 60), axis: (x: -1, y: 1, z: 0))
                                .blur(radius: phase.isIdentity ? 0 : 60)
                                .offset(x: phase.isIdentity ? 0 : -200)
                        }
                    
                }
            }
            .scrollTargetLayout()
            .padding(.vertical, 100)
            .task(id: hasReachedEnd) {
                await vm.fetchNextSetOfGames()
            }
            .if(hasReachedEnd) { view in
                view
                    .padding(.bottom, 100)
                    .overlay(alignment: .bottom) {
                        ZStack(alignment: .center) {
                            ProgressView()
                                .controlSize(.large)
                        }
                        .hSpacing(.center)
                        .frame(height: 100)
                    }
            }
        }
        .scrollTargetBehavior(.viewAligned)
    }
}


extension Color {
    static let bottomSheetBorderMiddle = LinearGradient(gradient: Gradient(stops: [.init(color: .white, location: 0), .init(color: .clear, location: 0.2)]),
                                                        startPoint: .top,
                                                        endPoint: .bottom)
    static let bottomSheetBackground = LinearGradient(gradient: Gradient(colors: [appTint.opacity(0.26), appTint.opacity(0.26)]),
                                                      startPoint: .topLeading,
                                                      endPoint: .bottomTrailing)
}
