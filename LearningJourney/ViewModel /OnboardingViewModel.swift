//
//  OnboardingViewModel.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 27/10/2025.
//

import Foundation
import SwiftUI

@Observable
class OnboardingViewModel {
    var subject: String = ""
    var selectedDuration: LearnerModel.Duration = .week
    var startDate: Date = Date()
    //Object of the LearnerModel
    var learner = LearnerModel()
    
    func createLearner() {
        // استخدم المصدر الموحد لقيمة الحد
        let limit = selectedDuration.defaultFreezeLimit
        learner = LearnerModel(
            subject: subject,
            duration: selectedDuration,
            startDate: startDate,
            streak: 0,
            freezeCount: 0,
            freezeLimit: limit,
            loggedDates: [],
            freezedDates: []
        )
    }
    
    func selectDuration(_ duration: LearnerModel.Duration) {
        selectedDuration = duration
    }
}
//class

