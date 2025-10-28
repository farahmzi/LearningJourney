//
//  StreakFreeszeView.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 27/10/2025.
//

import SwiftUI

struct StreakFreezeView: View {
    var count: Int
    var singular: String
    var plural: String
    var body: some View {
        VStack (alignment: .leading) {
            Text("\(count)")
                .font(.system(size: 24))
                .bold()
                .foregroundStyle(Color.white)
            Text(count == 1 ? singular : plural)
                .font(.system(size: 12))
                .foregroundStyle(Color.white)
        }
    }
}
