//
//  Int+Extension.swift
//  JustGames
//
//  Created by Ali Dinç on 17/12/2023.
//

import Foundation

extension Int {
    
    func numberToYear() -> String {
        let date = self.numberToDate()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "YYYY"
        return formatter.string(from: date)
    }
    
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
