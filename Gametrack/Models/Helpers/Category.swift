//
//  Category.swift
//  UINews
//
//  Created by Ali Dinç on 22/11/2022.
//

import Foundation

enum Category: String, CaseIterable {
    
    case database
    case topRated
    case newReleases
    case upcoming
    case upcomingThisWeek
    case upcomingThisMonth
    
    var `where`: String {
        switch self {
        case .topRated:
            return "total_rating > 10 & cover.url != n"
        case .newReleases:
            return "first_release_date > \(threeMonthsBackIntervalString) & first_release_date < \(todayIntervalString) & cover.url != n"
        case .upcoming:
            return "release_dates.date > \(todayIntervalString) & cover.url != n"
        case .upcomingThisWeek:
            return "release_dates.date < \(thisWeekIntervalString) & release_dates.date > \(todayIntervalString) & cover.url != n"
        case .upcomingThisMonth:
            return "release_dates.date < \(thisMonthIntervalString) & release_dates.date > \(todayIntervalString) & cover.url != n"
        case .database:
            return "cover.url != n"
        }
    }
    
    var sort: String {
        switch self {
        case .upcoming, .upcomingThisWeek, .upcomingThisMonth:
            return "release_dates.date"
        case .newReleases:
            return "first_release_date"
        default:
            return "total_rating"
        }
    }
    
    var sortBy: Sort {
        switch self {
        case .topRated, .newReleases, .database:
            return .DESCENDING
        case .upcoming, .upcomingThisWeek, .upcomingThisMonth:
            return .ASCENDING
        }
    }
    
    var title: String {
        switch self {
        case .topRated:
            return "Top rated"
        case .newReleases:
            return "New releases"
        case .upcoming:
            return "Upcoming"
        case .upcomingThisWeek:
            return "Upcoming week"
        case .upcomingThisMonth:
            return "Upcoming month"
        case .database:
            return "Search"
        }
    }
    
    var systemImage: String {
        switch self {
        case .topRated:
            return "star.fill"
        case .newReleases:
            return "calendar"
        case .upcoming:
            return "calendar"
        case .upcomingThisWeek:
            return "calendar"
        case .upcomingThisMonth:
            return "calendar"
        case .database:
            return "gamecontroller.fill"
        }
    }
}

extension Category: Identifiable, Equatable {
    var id: Self { self }
}


let tenYearsPreviousInterval =  Calendar.current.date(byAdding: .year, value: -10, to: Date())?.timeIntervalSince1970
let tenYearsPreviousIntervalString = String(format: "%.0f", tenYearsPreviousInterval!)

let previousYearInterval = Calendar.current.date(byAdding: .year, value: -5, to: Date())?.timeIntervalSince1970
let previousYearIntervalString = String(format: "%.0f", previousYearInterval!)

let thisWeekInterval = Calendar.current.date(byAdding: .day, value: 7, to: Date())?.timeIntervalSince1970
let thisWeekIntervalString = String(format: "%.0f", thisWeekInterval!)

let thisMonthInterval = Calendar.current.date(byAdding: .month, value: 1, to: Date())?.timeIntervalSince1970
let thisMonthIntervalString = String(format: "%.0f", thisMonthInterval!)

let threeMonthsInterval = Calendar.current.date(byAdding: .month, value: -3, to: Date())?.timeIntervalSince1970
let threeMonthsBackIntervalString = String(format: "%.0f", threeMonthsInterval!)

let todayInterval = Date().timeIntervalSince1970
let todayIntervalString = String(format: "%.0f", Date().timeIntervalSince1970)
