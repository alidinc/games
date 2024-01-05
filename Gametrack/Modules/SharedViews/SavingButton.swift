//
//  SavingButton.swift
//  Gametrack
//
//  Created by Ali Dinç on 30/12/2023.
//

import SwiftData
import SwiftUI
import Combine

struct SavingButton: View {
    
    var game: Game
    var opacity: CGFloat
    var padding: CGFloat
    
    @Environment(SavingViewModel.self) private var vm: SavingViewModel
    @Environment(LibraryViewModel.self) private var libraryVM
    @Environment(\.modelContext) private var context
    
    @Query var games: [SavedGame]
    
    var bag = Bag()
    
    var didRemoteChange = NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange).receive(on: RunLoop.main)
    
    var body: some View {
        Menu {
            ForEach([LibraryType.wishlist,
                     LibraryType.purchased,
                     LibraryType.owned,
                     LibraryType.played], id: \.id) { library in
                Button {
                    handleToggle(game: game, library: library, games: games, context: context)
                    
                } label: {
                    HStack {
                        Text(library.title)
                        SFImage(name:  alreadyExists(game, games: games, in: library) ? library.selectedIconName : library.iconName)
                    }
                }
            }
        } label: {
            if let savedGame = games.first(where: { $0.game?.id == game.id }) {
                let library = savedGame.libraryType
                SFImage(name: library.selectedIconName, opacity: opacity, padding: padding, color: library.color)
            } else {
                SFImage(name: "bookmark", opacity: opacity, padding: padding)
            }
        }
//        .onReceive(didRemoteChange, perform: { _ in
//            libraryVM.filterSegment(games: games)
//        })
    }
    
    private func delete(game: Game, in games: [SavedGame], context: ModelContext) {
        if let gameToDelete = games.first(where: { $0.game?.id == game.id }) {
            context.delete(gameToDelete)
        }
    }
    
    private func add(game: Game, for library: LibraryType, context: ModelContext) {
        DispatchQueue.global(qos: .background).async {
            vm.getImageData(from: game)
        }
        
        let savedGame = SavedGame(library: library.id)
        
        do {
            savedGame.gameData = try JSONEncoder().encode(game)
        } catch {
            print("Error")
        }
        
        if let imageData = vm.imageData {
            savedGame.imageData = imageData
        }
       
        context.insert(savedGame)
    }
    
    func alreadyExists(_ game: Game, games: [SavedGame], in library: LibraryType) -> Bool {
        return ((games.first(where: {$0.game?.id == game.id && $0.libraryType == library })) != nil)
    }
    
    func handleToggle(game: Game, library: LibraryType, games: [SavedGame], context: ModelContext) {
        guard self.alreadyExists(game, games: games, in: library) else {
            delete(game: game, in: games, context: context)
            add(game: game, for: library, context: context)
            return
        }
        
        delete(game: game, in: games, context: context)
    }
}
