//
//  CalendarViewModel.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 27/10/2025.
//

import Foundation
internal import Combine

class CalendarViewModel: ObservableObject {
    @Published var currentDate: Date = Date()            // used for weekly view
    @Published var selectedMonth: Date = Date()          // which month this VM represents
    @Published var showMonthPicker: Bool = false
    
    @Published var weekDays: [String] = ["SUN","MON","TUE","WED","THU","FRI","SAT"]
    @Published var daysInWeek: [Day] = []
    @Published var daysInMonth: [Day] = []
    
    var learnerM: LearnerModel
    private var calendar = Calendar.current
    
    // UPDATED initializer — accept a selectedMonth
    init(learnerM: LearnerModel, selectedMonth: Date = Date()) {
        self.learnerM = learnerM
        self.selectedMonth = selectedMonth
        
        // Make currentDate align with selectedMonth for weeks if you prefer
        self.currentDate = selectedMonth
        
        generateWeekDays()
        generateMonthDays()
    }
    
    // Helper to change the month and regenerate
    func setMonth(_ month: Date) {
        selectedMonth = month
        // optionally sync currentDate too:
        currentDate = month
        generateMonthDays()
        generateWeekDays()
    }
    
    func generateWeekDays() {
        guard let weekStart = calendar.dateInterval(of: .weekOfMonth, for: currentDate)?.start else { return }
        daysInWeek = (0..<7).compactMap { offset in
            if let date = calendar.date(byAdding: .day, value: offset, to: weekStart) {
                return Day(
                    date: date,
                    isCurrent: calendar.isDateInToday(date),
                    isLogged: learnerM.loggedDates.contains { calendar.isDate($0, inSameDayAs: date) },
                    isFreezed: learnerM.freezedDates.contains { calendar.isDate($0, inSameDayAs: date) }
                )
            }
            return nil
        }
    }
    
    func generateMonthDays() {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedMonth) else { return }
        let daysCount = calendar.dateComponents([.day], from: monthInterval.start, to: monthInterval.end).day ?? 0
        
        daysInMonth = (0..<daysCount).compactMap { offset in
            if let date = calendar.date(byAdding: .day, value: offset, to: monthInterval.start) {
                return Day(
                    date: date,
                    isCurrent: calendar.isDateInToday(date),
                    isLogged: learnerM.loggedDates.contains { calendar.isDate($0, inSameDayAs: date) },
                    isFreezed: learnerM.freezedDates.contains { calendar.isDate($0, inSameDayAs: date) }
                )
            }
            return nil
        }
    }
    
    func goToNextWeek() {
        currentDate = calendar.date(byAdding: .weekOfMonth, value: 1, to: currentDate) ?? currentDate
        generateWeekDays()
    }
    
    func goToPreviousWeek() {
        currentDate = calendar.date(byAdding: .weekOfMonth, value: -1, to: currentDate) ?? currentDate
        generateWeekDays()
    }
    
    // month navigation: use setMonth so everything regenerates consistently
    func goToNextMonth() {
        if let next = calendar.date(byAdding: .month, value: 1, to: selectedMonth) {
            setMonth(next)
        }
    }
    
    func goToPreviousMonth() {
        if let prev = calendar.date(byAdding: .month, value: -1, to: selectedMonth) {
            setMonth(prev)
        }
    }
}
