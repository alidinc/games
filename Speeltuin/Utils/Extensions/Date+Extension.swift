//
//  Date+Extension.swift
//  Speeltuin
//
//  Created by Ali Dinç on 07/01/2024.
//

import Foundation

extension Date {
    func asString(style: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
