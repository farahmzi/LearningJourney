//
//  LearnerModel.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 28/10/2025.
//

import Foundation

struct LearnerModel: Identifiable, Codable {
    var id: UUID = UUID()
    var subject: String = ""
    var duration: Duration = .week
    var startDate: Date = Date()
    var streak: Int = 0
    var freezeCount: Int = 0
    var freezeLimit: Int = 0
    var loggedDates: [Date] = []
    var freezedDates: [Date] = []
    
    var endDate: Date {
        let calendar = Calendar.current
        switch duration {
        case .week:  return calendar.date(byAdding: .weekOfYear, value: 1, to: startDate)!
        case .month: return calendar.date(byAdding: .month, value: 1, to: startDate)!
        case .year:  return calendar.date(byAdding: .year, value: 1, to: startDate)!
        }
    }
    enum Duration: String, CaseIterable, Identifiable, Codable {
        case week, month, year
        var id: String { self.rawValue }
    }
}

