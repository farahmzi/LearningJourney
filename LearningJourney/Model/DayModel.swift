//
//  DayModel.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 28/10/2025.
//

import Foundation

struct Day: Identifiable {
    let id = UUID()
    let date: Date
    var isCurrent: Bool = false
    var isLogged: Bool = false
    var isFreezed: Bool = false
}
