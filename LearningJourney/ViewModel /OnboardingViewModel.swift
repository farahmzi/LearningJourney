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
        // احسب حدّ التجميد بناءً على المدة المختارة
        let limit: Int
        switch selectedDuration {
        case .week:  limit = 2
        case .month: limit = 8
        case .year:  limit = 96
        }
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
