//
//  String+Extension.swift
//  A-games
//
//  Created by Ali Dinç on 18/12/2023.
//

import Foundation

extension Date {
    
    var nowString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}
