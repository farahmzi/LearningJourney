//
//  CalendarView.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 27/10/2025.

import SwiftUI

struct CalendarView: View {
    // نستخدم StateObject هنا لأن هذه الصفحة تملك نسخة خاصة من ActivityViewModel
    @StateObject var activityVM: ActivityViewModel

    // مُهيّئ يستقبل المتعلّم ويهيّئ الـ VM
    init(learnerM: LearnerModel) {
        _activityVM = StateObject(wrappedValue: ActivityViewModel(learnerM: learnerM))
    }

    var body: some View {
        // قائمة قابلة للتمرير تعرض عدّة أشهر
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                ForEach(generateMonths(), id: \.self) { monthDate in
                    // إنشاء ViewModel للشهر المحدد لعرضه
                    let viewModel = CalendarViewModel(
                        learnerM: activityVM.learnerM,
                        selectedMonth: monthDate
                    )
                    // تقويم شهري لكل شهر مولّد
                    MonthlyCalendarView(viewModel: viewModel)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }

    // توليد مصفوفة تواريخ تمثل 6 أشهر قبل و6 أشهر بعد الشهر الحالي
    private func generateMonths() -> [Date] {
        let calendar = Calendar.current
        let current = Date()
        let monthsBefore = 6
        let monthsAfter = 6

        return (-monthsBefore...monthsAfter).compactMap {
            calendar.date(byAdding: .month, value: $0, to: current)
        }
    }
}

#Preview {
    CalendarView(learnerM: LearnerModel(
        subject: "Swift",
        duration: .month,
        startDate: Date(),
        streak: 3,
        freezeCount: 1,
        freezeLimit: 8
    ))
}

