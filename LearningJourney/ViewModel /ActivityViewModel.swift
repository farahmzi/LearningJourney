//
//  ActivityViewModel.swift
//  LearningJourney
//
//  Created by Yousra Abdelrahman on 01/05/1447 AH.
//
//

import Foundation
internal import Combine
import SwiftUI

@MainActor
class ActivityViewModel: ObservableObject {
    // نموذج المتعلّم الذي نديره
    @Published var learnerM: LearnerModel
    // هل تحقق الهدف الحالي؟
    @Published var isAchieved: Bool =  false

    // حالة داخلية
    @Published var lastLoggedDate: Date?            // آخر يوم تم تسجيله (تعلم/فريز)
    @Published var isLogButtonDisabled = false      // تعطيل زر "Log as Learned" حتى منتصف الليل بعد الاستخدام
    @Published var isFreezeButtonDisabled = false   // تعطيل زر "Log as freezed" في حالات معينة

    @Published var didUseFreezeToday = false        // هل تم استخدام فريز اليوم؟
    @Published var isOutOfFreeze = false            // هل انتهى رصيد الفريزات؟

    // مؤقّت لإعادة تفعيل الأزرار عند منتصف الليل
    private var midnightTimer: Timer?

    // MARK: - Initializer
    init(learnerM: LearnerModel) {
        self.learnerM = learnerM
        setupFreezeLimit()     // اضبط حد الفريز الافتراضي حسب المدة
        setupMidnightReset()   // جهّز مؤقّت منتصف الليل
        updateButtonStates()   // حدّث حالات الأزرار
        isGoalAchieved()       // تحقق أولي من تحقيق الهدف
    }

    // MARK: - Setup
    private func setupFreezeLimit() {
        // استخدم المصدر الموحد من Duration لضمان الاتساق
        learnerM.freezeLimit = learnerM.duration.defaultFreezeLimit
    }

    // MARK: - Actions
    func logAsLearned() {
        guard !isLogButtonDisabled else { return }
        // زيادة الستريك وتسجيل تاريخ اليوم
        learnerM.streak += 1
        learnerM.loggedDates.append(Date())
        lastLoggedDate = Date()
        // تعطيل الأزرار حتى منتصف الليل
        disableButtonsUntilMidnight()
        // تحقق من تحقيق الهدف بعد التحديث
        isGoalAchieved()
    }

    func useFreeze() {
        guard !isFreezeButtonDisabled else { return }
        // إذا تجاوزنا حد الفريزات، اعتبر أننا خرجنا من الرصيد
        guard learnerM.freezeCount < learnerM.freezeLimit else {
            isOutOfFreeze = true
            return
        }
        // زيادة عدد الفريز وتسجيل التاريخ
        learnerM.freezeCount += 1
        learnerM.freezedDates.append(Date())
        lastLoggedDate = Date()
        didUseFreezeToday = true
        // تعطيل الأزرار حتى منتصف الليل
        disableButtonsUntilMidnight()
        // تحقق من تحقيق الهدف
        isGoalAchieved()
    }

    // MARK: - Resetting and Conditions
    func checkStreakResetCondition() {
        // إذا مر أكثر من 32 ساعة على آخر تسجيل، صفّر الستريك (حسب سياسة التطبيق)
        guard let last = lastLoggedDate else { return }
        let hoursPassed = Date().timeIntervalSince(last) / 3600
        if hoursPassed > 32 {
            learnerM.streak = 0
        }
    }

    func resetForNewGoal() {
        // يُستدعى عند تغيير الهدف/المدة/تاريخ البداية
        learnerM.streak = 0
        learnerM.freezeCount = 0
        learnerM.loggedDates = []
        learnerM.freezedDates = []
        setupFreezeLimit()      // إعادة ضبط حد الفريز حسب المدة
        lastLoggedDate = nil
        didUseFreezeToday = false
        isOutOfFreeze = false
        isAchieved = false
        updateButtonStates()
    }

    // MARK: - Helpers for Button States
    private func updateButtonStates() {
        // تعطيل زر الفريز إذا بلغنا الحد
        isFreezeButtonDisabled = learnerM.freezeCount >= learnerM.freezeLimit
        isOutOfFreeze = learnerM.freezeCount >= learnerM.freezeLimit
        // افتراضيًا زر التعلم مفعّل إلى أن يُستخدم اليوم
        isLogButtonDisabled = false
    }

    private func disableButtonsUntilMidnight() {
        // إيقاف الأزرار بعد الاستخدام حتى منتصف الليل
        isLogButtonDisabled = true
        isFreezeButtonDisabled = true
    }

    // MARK: - Midnight Reset
    private func setupMidnightReset() {
        // حساب موعد منتصف الليل القادم
        let calendar = Calendar.current
        let now = Date()
        if let nextMidnight = calendar.nextDate(
            after: now,
            matching: DateComponents(hour: 0, minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) {
            let interval = nextMidnight.timeIntervalSinceNow
            // جدولة مؤقّت مرة واحدة حتى منتصف الليل
            midnightTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
                self?.enableButtonsAtMidnight()
            }
        }
    }

    private func enableButtonsAtMidnight() {
        // إعادة تفعيل الأزرار عند منتصف الليل
        isLogButtonDisabled = false
        isFreezeButtonDisabled = learnerM.freezeCount >= learnerM.freezeLimit
        didUseFreezeToday = false
        // جدولة المؤقّت لليوم التالي
        setupMidnightReset()
    }

    // MARK: - Goal Achievement
    func isGoalAchieved() {
        let total = getDayCount(learnerM.duration)
        // نعتبر الهدف متحققًا إذا مجموع (الستريك + الفريز) وصل أو تجاوز العدد المطلوب
        self.isAchieved = learnerM.freezeCount + learnerM.streak >= total
    }

    // عدد الأيام المطلوب بحسب المدة
    func getDayCount(_ duration: LearnerModel.Duration ) -> Int{
        switch duration {
        case .week:
            return 7
        case .month:
            return 30
        case .year:
            return 365
        }
    }
    
    deinit {
        // إيقاف المؤقّت عند تحرير الـ ViewModel
        midnightTimer?.invalidate()
    }
}

