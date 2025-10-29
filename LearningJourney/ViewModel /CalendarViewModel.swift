//
//  CalendarViewModel.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 27/10/2025.
//

import Foundation
internal import Combine

class CalendarViewModel: ObservableObject {
    // تاريخ الأسبوع الحالي لعرض التقويم الأسبوعي
    @Published var currentDate: Date = Date()
    // الشهر المختار لعرض التقويم الشهري
    @Published var selectedMonth: Date = Date()
    // إظهار/إخفاء منتقي الشهر داخل العرض الأسبوعي
    @Published var showMonthPicker: Bool = false
    
    // أسماء أيام الأسبوع
    @Published var weekDays: [String] = ["SUN","MON","TUE","WED","THU","FRI","SAT"]
    // الأيام التي سيتم عرضها في الأسبوع والشهر
    @Published var daysInWeek: [Day] = []
    @Published var daysInMonth: [Day] = []
    
    // نموذج المتعلّم للوصول إلى تواريخ التعلم والفريز
    var learnerM: LearnerModel
    private var calendar = Calendar.current
    
    // مُهيّئ يقبل شهر محدد لبدء العرض منه
    init(learnerM: LearnerModel, selectedMonth: Date = Date()) {
        self.learnerM = learnerM
        self.selectedMonth = selectedMonth
        // مزامنة currentDate مع selectedMonth لعرض أسبوع من نفس الشهر
        self.currentDate = selectedMonth
        
        generateWeekDays()
        generateMonthDays()
    }
    
    // تغيير الشهر وإعادة توليد الأيام
    func setMonth(_ month: Date) {
        selectedMonth = month
        currentDate = month
        generateMonthDays()
        generateWeekDays()
    }
    
    // توليد بيانات أيام الأسبوع الحالي
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
    
    // توليد بيانات أيام الشهر المختار
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
    
    // تنقّل أسبوعي للأمام والخلف
    func goToNextWeek() {
        currentDate = calendar.date(byAdding: .weekOfMonth, value: 1, to: currentDate) ?? currentDate
        generateWeekDays()
    }
    
    func goToPreviousWeek() {
        currentDate = calendar.date(byAdding: .weekOfMonth, value: -1, to: currentDate) ?? currentDate
        generateWeekDays()
    }
    
    // تنقّل شهري للأمام والخلف
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

