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
    // The model this VM manages
    @Published var learnerM: LearnerModel
    @Published var isAchieved: Bool =  false

    // State
    @Published var lastLoggedDate: Date?
    @Published var isLogButtonDisabled = false
    @Published var isFreezeButtonDisabled = false

    @Published var didUseFreezeToday = false
    @Published var isOutOfFreeze = false

    // Timer to re-enable buttons at midnight
    private var midnightTimer: Timer?

    // MARK: - Initializer
    init(learnerM: LearnerModel) {
        self.learnerM = learnerM
        setupFreezeLimit()
        setupMidnightReset()
        updateButtonStates()
    }

    // MARK: - Setup
    private func setupFreezeLimit() {
        // Ensure freezeLimit matches the selected duration
        switch learnerM.duration {
        case .week:  learnerM.freezeLimit = 2
        case .month: learnerM.freezeLimit = 8
        case .year:  learnerM.freezeLimit = 96
        }
    }

    // MARK: - Actions
    func logAsLearned() {
        guard !isLogButtonDisabled else { return }
        learnerM.streak += 1
        learnerM.loggedDates.append(Date())
        lastLoggedDate = Date()
        disableButtonsUntilMidnight()
    }

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
        disableButtonsUntilMidnight()
    }

    // MARK: - Resetting and Conditions
    func checkStreakResetCondition() {
        // If more than 32 hours passed since last log or freeze
        guard let last = lastLoggedDate else { return }
        let hoursPassed = Date().timeIntervalSince(last) / 3600
        if hoursPassed > 32 {
            learnerM.streak = 0
        }
    }

    func resetForNewGoal() {
        // Caller updates subject/duration/startDate beforehand
        learnerM.streak = 0
        learnerM.freezeCount = 0
        learnerM.loggedDates = []
        learnerM.freezedDates = []
        setupFreezeLimit()
        lastLoggedDate = nil
        didUseFreezeToday = false
        isOutOfFreeze = false
        updateButtonStates()
    }

    // MARK: - Helpers for Button States
    private func updateButtonStates() {
        isFreezeButtonDisabled = learnerM.freezeCount >= learnerM.freezeLimit
        isOutOfFreeze = learnerM.freezeCount >= learnerM.freezeLimit
        isLogButtonDisabled = false
    }

    private func disableButtonsUntilMidnight() {
        isLogButtonDisabled = true
        isFreezeButtonDisabled = true
    }

    // MARK: - Midnight Reset
    private func setupMidnightReset() {
        let calendar = Calendar.current
        let now = Date()
        if let nextMidnight = calendar.nextDate(
            after: now,
            matching: DateComponents(hour: 0, minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) {
            let interval = nextMidnight.timeIntervalSinceNow
            midnightTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
                self?.enableButtonsAtMidnight()
            }
        }
    }

    private func enableButtonsAtMidnight() {
        isLogButtonDisabled = false
        isFreezeButtonDisabled = learnerM.freezeCount >= learnerM.freezeLimit
        didUseFreezeToday = false
        setupMidnightReset() // schedule again for next day
    }

    
    func isGoalAchieved() {
        
        let total = getDayCount(learnerM.duration)
        
        // if it is less than the total days then the goal still not achieved
        self.isAchieved = learnerM.freezeCount + learnerM.streak > total
    }
    
    
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
        midnightTimer?.invalidate()
    }
}
