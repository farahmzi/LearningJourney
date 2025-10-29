//
//  MonthlyCalendarView.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 27/10/2025.
//

import SwiftUI

struct MonthlyCalendarView: View {
    // ViewModel خاص بالتقويم الشهري
    @ObservedObject var viewModel: CalendarViewModel
    // شبكة 7 أعمدة لأيام الأسبوع
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        VStack {
            // عنوان الشهر والسنة
            HStack {
                Text(viewModel.selectedMonth, format: .dateTime.month().year())
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding()
            
            // شبكة الأيام
            LazyVGrid(columns: columns) {
                // عناوين أيام الأسبوع
                ForEach(viewModel.weekDays, id: \.self) { day in
                    Text(day)
                }
                
                // الأيام مع تلوين حسب الحالة (اليوم الحالي/مسجل/مجمد)
                ForEach(viewModel.daysInMonth) { day in
                    Text("\(Calendar.current.component(.day, from: day.date))")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(8)
                        .background(day.isCurrent ? Color.flameOranage : (day.isLogged ? Color.streakBG : (day.isFreezed ? Color.freezeBG : Color.clear)))
                        .clipShape(Circle())
                        .foregroundColor(day.isCurrent || day.isLogged || day.isFreezed ? .white : .white)
                }
            }
        }
    }
}

