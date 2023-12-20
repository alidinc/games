//
//  Int+Extension.swift
//  A-games
//
//  Created by Ali Dinç on 17/12/2023.
//

import Foundation

extension Int {
    
    func numberToDateString() -> String {
        let date = self.numberToDate()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func numberToDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}
