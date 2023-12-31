//
//  FetchTaskToken.swift
//  Gameraw
//
//  Created by Ali Dinç on 26/11/2022.
//

import Foundation

struct FetchTaskToken: Equatable, Hashable {
    var category: Category
    var platforms: [PopularPlatform]
    var genres: [PopularGenre]
    var token: Date
}
