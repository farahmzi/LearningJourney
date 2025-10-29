//
//  ContentView.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 27/10/2025.
//

import SwiftUI

@main
struct LearningJourneyApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentLearner: LearnerModel? = nil
    
    init() {
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if hasCompletedOnboarding, let learner = currentLearner {
                    // اختَر الواجهة حسب المدة
                    destinationView(for: learner)
                } else {
                    OnboardingView { learner in
                        currentLearner = learner
                        hasCompletedOnboarding = true
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for learner: LearnerModel) -> some View {
        switch learner.duration {
        case .week:
            ActivityView(learnerM: learner)
        case .month:
            ActivityView(learnerM: learner)
        case .year:
            ActivityView(learnerM: learner)
        }
    }
}
