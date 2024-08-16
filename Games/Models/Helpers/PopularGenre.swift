//
//  PopularGenre.swift
//  Speeltuin
//
//  Created by Ali Dinc on 27/02/2023.
//

import SwiftUI

enum PopularGenre: Int, CaseIterable, Equatable, Identifiable {
    
    case allGenres
    case fighting = 4
    case shooter = 5
    case music = 7
    case platform = 8
    case puzzle = 9
    case racing = 10
    case realTimeStrategy = 11
    case rolePlaying = 12
    case simulator = 13
    case sport = 14
    case strategy = 15
    case turnBasedStrategy = 16
    case tactical = 24
    case quizTrivia = 26
    case hackSlash = 25
    case pinball = 30
    case adventure = 31
    case arcade = 33
    case visualNovel = 34
    case indie = 32
    case cardBoard = 35
    case moba = 36
    case pointClick = 2
   
    var id: Int {
        switch self {
        default:
            return self.rawValue
        }
    }
    
    var title: String {
        switch self {
        case .fighting:
            return "Fighting"
        case .shooter:
            return "Shooter"
        case .music:
            return "Music"
        case .platform:
            return "Platform"
        case .puzzle:
            return "Puzzle"
        case .racing:
            return "Racing"
        case .realTimeStrategy:
            return "Real time strategy"
        case .rolePlaying:
            return "Role-playing"
        case .simulator:
            return "Simulator"
        case .sport:
            return "Sport"
        case .strategy:
            return "Strategy"
        case .turnBasedStrategy:
            return "Turn based strategy"
        case .tactical:
            return "Tactical"
        case .quizTrivia:
            return "Quiz/Trivia"
        case .hackSlash:
            return "Beat-slash"
        case .pinball:
            return "Pinball"
        case .adventure:
            return "Adventure"
        case .arcade:
            return "Arcade"
        case .visualNovel:
            return "Visual novel"
        case .indie:
            return "indie"
        case .cardBoard:
            return "Board game"
        case .moba:
            return "Real-time-strategy"
        case .pointClick:
            return "Point-click"
        case .allGenres:
            return "Genres"
        }
    }
    
    var assetName: String {
        switch self {
        case .fighting:
            return "fighting"
        case .shooter:
            return "shooter"
        case .music:
            return "music"
        case .platform:
            return "platform"
        case .puzzle:
            return "puzzle"
        case .racing:
            return "racing"
        case .realTimeStrategy:
            return "real-time-strategy"
        case .rolePlaying:
            return "role-playing"
        case .simulator:
            return "simulator"
        case .sport:
            return "sport"
        case .strategy:
            return "strategy"
        case .turnBasedStrategy:
            return "strategy"
        case .tactical:
            return "strategy"
        case .quizTrivia:
            return "quiz"
        case .hackSlash:
            return "beat-slash"
        case .pinball:
            return "pinball"
        case .adventure:
            return "adventure"
        case .arcade:
            return "arcade"
        case .visualNovel:
            return "visual-novel"
        case .indie:
            return "indie"
        case .cardBoard:
            return "board-game"
        case .moba:
            return "real-time-strategy"
        case .pointClick:
            return "point-click"
        case .allGenres:
            return "filter"
        }
    }
}
