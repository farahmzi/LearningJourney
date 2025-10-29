//
//  CompactCalendarView.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 27/10/2025.
//

import SwiftUI

struct CompactCalendarView: View {
    // ملاحظة: نستخدم ObservedObject لأن المالك الحقيقي خارجي
    @ObservedObject var calendarVM: CalendarViewModel
    @ObservedObject var activityVM: ActivityViewModel
 
    var body: some View {
        ZStack {
            // خلفية زجاجية خفيفة للبطاقة
            RoundedRectangle(cornerRadius:13, style: .continuous)
                .fill(Color.gray.opacity(0.25))
                .stroke(Color.gray, lineWidth: 0.5)
                .opacity(0.5)
            VStack(alignment: .leading) {
                // عرض أسبوعي مضغوط داخل البطاقة
                WeeklyCalendarView(calendarVM: calendarVM, activityVM: activityVM)
                    .previewLayout(.sizeThatFits)
            }
        }
        .frame(width: 350, height: 254)
    }
}

