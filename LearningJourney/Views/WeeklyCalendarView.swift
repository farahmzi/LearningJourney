//
//  WeeklyCalendarView.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 28/10/2025.
//

import SwiftUI

struct WeeklyCalendarView: View {
    // نستخدم ObservedObject لأن المالك للـ VMs خارجي
    @ObservedObject var calendarVM: CalendarViewModel
    @ObservedObject var activityVM: ActivityViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 10) {
            // MARK: - رأس العرض: اسم الشهر والسنة + أسهم تنقل الأسبوع
            HStack {
                // زر لإظهار/إخفاء منتقي الشهر (Wheel)
                Button {
                    withAnimation(.easeInOut) {
                        calendarVM.showMonthPicker.toggle()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(calendarVM.selectedMonth.formatted(.dateTime.month().year()))
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .rotationEffect(.degrees(calendarVM.showMonthPicker ? 180 : 0))
                            .foregroundColor(.flameOranage)
                    }
                }
                .buttonStyle(.plain)
                
                Spacer()
                // تنقّل بين الأسابيع
                HStack(spacing: 16) {
                    Button(action: { calendarVM.goToPreviousWeek() }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.flameOranage)
                    }
                    Button(action: { calendarVM.goToNextWeek() }) {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.flameOranage)
                    }
                }
            }
            .padding(.horizontal)
            
            // MARK: - منتقي الشهر المضمّن
            if calendarVM.showMonthPicker {
                DatePicker(
                    "",
                    selection: $calendarVM.selectedMonth,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(maxHeight: 189)
                .transition(.opacity.combined(with: .move(edge: .top)))
                .onChange(of: calendarVM.selectedMonth) { _ in
                    // إعادة توليد أيام الأسبوع عند تغيير الشهر
                    calendarVM.generateWeekDays()
                }
            }
            
            // MARK: - محتوى الأسبوع (يختفي عند فتح منتقي الشهر)
            if !calendarVM.showMonthPicker {
                VStack {
                    // عناوين أيام الأسبوع
                    HStack {
                        ForEach(calendarVM.weekDays, id: \.self) { day in
                            Text(day)
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                    }

                    // أرقام أيام الأسبوع مع التلوين حسب الحالة
                    HStack {
                        ForEach(calendarVM.daysInWeek) { day in
                            Text("\(Calendar.current.component(.day, from: day.date))")
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 16, weight: .bold))
                                .padding(6)
                                .foregroundColor(foregroundColor(for: day))
                                .background(backgroundColor(for: day))
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                    }
                    
                    Divider()
                        .padding(.bottom, 12)
                    
                    // عنوان يوضح المادة الحالية
                    HStack {
                        Text("Learning \(activityVM.learnerM.subject)")
                            .font(.system(size: 16))
                            .bold()
                        Spacer()
                    }
                    .padding(.bottom, 12)
                    
                    // بطاقتان: الستريك والفريز
                    HStack {
                        // بطاقة الستريك
                        ZStack {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color.clear)
                                .frame(width: 160, height: 69)
                                .glassEffect(.clear.tint(.streakBG))
                            HStack {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 15))
                                    .foregroundStyle(Color.flameOranage)
                                // عرض العدد مع نص مفرد/جمع
                                StreakFreezeView(count: activityVM.learnerM.streak, singular: "Day Streak", plural: "Days Streak")
                            }
                        }
                        .padding(.trailing, 13)
                        
                        // بطاقة الفريز
                        ZStack {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color.clear)
                                .frame(width: 160, height: 69)
                                .glassEffect(.clear.tint(.freezeBG))
                            HStack {
                                Image(systemName: "cube.fill")
                                    .font(.system(size: 15))
                                    .foregroundStyle(Color.cubeBlue)
                                StreakFreezeView(count: activityVM.learnerM.freezeCount, singular: "Day Frozen", plural: "Days Frozen")
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .animation(.easeInOut, value: calendarVM.showMonthPicker)
    }

    // MARK: - Helper: لون الخلفية حسب حالة اليوم
    private func backgroundColor(for day: Day) -> Color {
        if day.isCurrent { return (activityVM.isLogButtonDisabled ? (activityVM.didUseFreezeToday ? .freezePrimaryButton : .streakBG ) : .currentDayCalendar) }
        if day.isLogged { return .streakBG }
        if day.isFreezed { return .freezeBG }
        return .clear
    }
    // لون النص حسب حالة اليوم
    private func foregroundColor(for: Day) -> Color {
        if `for`.isCurrent { return (activityVM.isLogButtonDisabled ? (activityVM.didUseFreezeToday ? .cubeBlue : .flameOranage) : .white) }
        if `for`.isLogged { return .flameOranage }
        if `for`.isFreezed { return .cubeBlue }
        return .white
    }
}

