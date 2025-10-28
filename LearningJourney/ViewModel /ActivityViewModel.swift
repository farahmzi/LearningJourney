//
//  ActivityViewModel.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 27/10/2025.
//

import Foundation
internal import Combine

@MainActor
class ActivityViewModel: ObservableObject {
    @Published var learnerM = LearnerModel()
    @Published var lastLoggedDate: Date?
    @Published var isLogButtonDisabled = false
    @Published var isFreezeButtonDisabled = false
    
    @Published var didUseFreezeToday = false
    @Published var isOutOfFreeze = false
    
    // Timers
    private var midnightTimer: Timer?
    private var hourlyCheckTimer: Timer?
    
    // Storage keys
    private let learnerKey = "LearnerModelStorage"
    private let lastLogKey = "LastLoggedDateStorage"
    private let didUseFreezeTodayKey = "DidUseFreezeToday"
    
    init(learnerM: LearnerModel) {
        // حمّل أي بيانات محفوظة إن وجدت، وإلا استخدم الممرّ
        if let saved = Self.loadLearner(from: learnerKey) {
            self.learnerM = saved
        } else {
            self.learnerM = learnerM
        }
        self.lastLoggedDate = Self.loadDate(from: lastLogKey)
        self.didUseFreezeToday = UserDefaults.standard.bool(forKey: didUseFreezeTodayKey)
        
        setupFreezeLimit()
        setupMidnightReset()
        setupHourlyCheck()
        updateButtonStates()
        checkStreakResetCondition()
    }
    
    // MARK: - Setup
    private func setupFreezeLimit() {
        switch learnerM.duration {
        case .week:  learnerM.freezeLimit = 2
        case .month: learnerM.freezeLimit = 8
        case .year:  learnerM.freezeLimit = 96
        }
        saveLearner()
    }
    
    // MARK: - Logging Learning
    func logAsLearned() {
        guard !isLogButtonDisabled else { return }
        learnerM.streak += 1
        learnerM.loggedDates.append(Date())
        lastLoggedDate = Date()
        saveLearner()
        saveLastLog()
        disableButtonsUntilMidnight()
    }
    
    // MARK: - Using a Freeze
    func useFreeze() {
        guard !isFreezeButtonDisabled else { return }
        guard learnerM.freezeCount < learnerM.freezeLimit else {
            isOutOfFreeze = true
            return
        }
        learnerM.freezeCount += 1
        learnerM.freezedDates.append(Date())
        lastLoggedDate = Date()
        didUseFreezeToday = true
        saveLearner()
        saveLastLog()
        UserDefaults.standard.set(true, forKey: didUseFreezeTodayKey)
        disableButtonsUntilMidnight()
    }
    
    // MARK: - Resetting and Conditions
    func checkStreakResetCondition() {
        // إذا لا يوجد آخر تسجيل، لا شيء يُفعل
        guard let last = lastLoggedDate else { return }
        let hoursPassed = Date().timeIntervalSince(last) / 3600.0
        if hoursPassed > 32 {
            learnerM.streak = 0
            saveLearner()
        }
        updateButtonStates()
    }
    
    func resetForNewGoal() {
        learnerM.streak = 0
        learnerM.freezeCount = 0
        learnerM.loggedDates.removeAll()
        learnerM.freezedDates.removeAll()
        lastLoggedDate = nil
        didUseFreezeToday = false
        saveLearner()
        saveLastLog()
        UserDefaults.standard.set(false, forKey: didUseFreezeTodayKey)
        setupFreezeLimit()
        updateButtonStates()
    }
    
    // MARK: - Helpers for Button States
    private func updateButtonStates() {
        isFreezeButtonDisabled = learnerM.freezeCount >= learnerM.freezeLimit || isLogButtonDisabled
        isOutOfFreeze = learnerM.freezeCount >= learnerM.freezeLimit
        // isLogButtonDisabled يتم التحكم به عند التسجيل/منتصف الليل
    }
    
    private func disableButtonsUntilMidnight() {
        isLogButtonDisabled = true
        isFreezeButtonDisabled = true
    }
    
    // MARK: - Midnight Reset
    private func setupMidnightReset() {
        midnightTimer?.invalidate()
        let calendar = Calendar.current
        let now = Date()
        if let nextMidnight = calendar.nextDate(after: now, matching: DateComponents(hour: 0, minute: 0), matchingPolicy: .nextTime) {
            let interval = max(1, nextMidnight.timeIntervalSinceNow)
            midnightTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
                self?.enableButtonsAtMidnight()
            }
        }
    }
    
    private func enableButtonsAtMidnight() {
        isLogButtonDisabled = false
        isFreezeButtonDisabled = learnerM.freezeCount >= learnerM.freezeLimit
        didUseFreezeToday = false
        UserDefaults.standard.set(false, forKey: didUseFreezeTodayKey)
        // تحقق من 32 ساعة أيضًا عند تبديّل اليوم
        checkStreakResetCondition()
        setupMidnightReset()
    }
    
    // MARK: - Hourly soft check (32h rule)
    private func setupHourlyCheck() {
        hourlyCheckTimer?.invalidate()
        hourlyCheckTimer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.checkStreakResetCondition()
            }
        }
    }
    
    deinit {
        midnightTimer?.invalidate()
        hourlyCheckTimer?.invalidate()
    }
    
    // MARK: - Persistence (UserDefaults + Codable)
    private func saveLearner() {
        Self.saveLearner(learnerM, to: learnerKey)
    }
    private func saveLastLog() {
        Self.saveDate(lastLoggedDate, to: lastLogKey)
    }
    
    private static func saveLearner(_ learner: LearnerModel, to key: String) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(learner) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    private static func loadLearner(from key: String) -> LearnerModel? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(LearnerModel.self, from: data)
    }
    private static func saveDate(_ date: Date?, to key: String) {
        if let date = date {
            UserDefaults.standard.set(date.timeIntervalSince1970, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    private static func loadDate(from key: String) -> Date? {
        let ts = UserDefaults.standard.double(forKey: key)
        return ts > 0 ? Date(timeIntervalSince1970: ts) : nil
    }
}

