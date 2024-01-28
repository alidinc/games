//
//  GamesTabCoordinator.swift
//  Speeltuin
//
//  Created by alidinc on 26/01/2024.
//

import SwiftUI

class GamesTabCoordinator: ParentCoordinator {
    
    @State var vm = GamesViewModel()
    
    override init() {
        super.init()
    }
}
