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
    
    // End-of-period per spec, using local start-of-day boundaries
    var endDate: Date {
        periodEndDate(using: Calendar.current)
    }
    
    func periodEndDate(using calendar: Calendar) -> Date {
        let start = calendar.startOfDay(for: startDate)
        switch duration {
        case .week:
            // 7 consecutive days: end at start-of-day after 7th day
            return calendar.date(byAdding: .day, value: 7, to: start)!
        case .month:
            // End of that calendar month at local start-of-day (the day after the last day)
            let comps = calendar.dateComponents([.year, .month], from: start)
            // first day of month
            let monthStart = calendar.date(from: comps)!
            // next month start
            let nextMonthStart = calendar.date(byAdding: .month, value: 1, to: monthStart)!
            return nextMonthStart // start-of-day of next month
        case .year:
            // End of that calendar year at local start-of-day (Jan 1 next year)
            let year = calendar.component(.year, from: start)
            // Jan 1 of next year at start-of-day
            var nextYearComps = DateComponents()
            nextYearComps.year = year + 1
            nextYearComps.month = 1
            nextYearComps.day = 1
            let nextYearStart = calendar.date(from: nextYearComps)!
            return calendar.startOfDay(for: nextYearStart)
        }
    }
    
    enum Duration: String, CaseIterable, Identifiable, Codable {
        case week, month, year
        var id: String { self.rawValue }
        
        // مصدر وحيد لقيمة حدّ التجميد الافتراضي
        var defaultFreezeLimit: Int {
            switch self {
            case .week:  return 2
            case .month: return 8
            case .year:  return 96
            }
        }
    }
}

