//
//  GameDetailViewModel.swift
//  Gametrack
//
//  Created by Ali Dinç on 24/12/2023.
//

import SwiftUI
import Observation

@Observable
class GameDetailViewModel {
    
    var companies: [Company] = []
   
    func fetchCompanies(for game: Game) async {
        do {
            let response = try await NetworkManager.shared.fetchCompanies()
            let responseIds = response.map { $0.id }
            if let gameInvolvedCompanyIds = game.involvedCompanies {
                let matchingCompanyIds = gameInvolvedCompanyIds.filter({ gameInvolvedCompanyIds.contains($0) })
                let matchingCompanies = response.filter({ matchingCompanyIds.contains($0.id) })
                self.companies = matchingCompanies
            }
        } catch {
            self.companies = []
        }
    }
}
