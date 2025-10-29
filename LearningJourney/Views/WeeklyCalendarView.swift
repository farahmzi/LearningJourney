//
//  WeeklyCalendarView.swift
//  LearningJourney
//
//  Created by Yousra Abdelrahman on 04/05/1447 AH.
//
import SwiftUI

struct WeeklyCalendarView: View {
    @ObservedObject var calendarVM: CalendarViewModel
    @ObservedObject var activityVM: ActivityViewModel
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(spacing: 10) {
            // MARK: - Header: Month + Year with Arrow
            HStack {
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
                // Week navigation
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
            // MARK: - Inline Month Picker
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
                    calendarVM.generateWeekDays()
                }
            }
            // MARK: - Hidden Content When Month Picker Expanded
            if !calendarVM.showMonthPicker {
                VStack {
                    // Weekday Titles
                    HStack {
                        ForEach(calendarVM.weekDays, id: \.self) { day in
                            Text(day)
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                    }

                    // Week Days
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
                    //Added by me
                    HStack{
                        Text("Learning \(activityVM.learnerM.subject)")
                            .font(.system(size: 16))
                            .bold()
                        Spacer() //To change the aligment of the text to be leading
                    }
                    .padding(.bottom, 12)
                    HStack {
                        ZStack{
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color.clear)
                                .frame(width: 160, height: 69)
                                .glassEffect(.clear.tint(.streakBG))
                            HStack{
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 15))
                                    .foregroundStyle(Color.flameOranage)
                                StreakFreezeView(count: activityVM.learnerM.streak, singular: "Day Streak", plural: "Days Streak")
                            }//HStack - For Flame, Count, and Text
                        }//ZStack - For Streak Overlaping
                        .padding(.trailing, 13)
                        ZStack{
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color.clear)
                                .frame(width: 160, height: 69)
                                .glassEffect(.clear.tint(.freezeBG))
                            HStack{
                                Image(systemName: "cube.fill")
                                    .font(.system(size: 15))
                                    .foregroundStyle(Color.cubeBlue)
                                StreakFreezeView(count: activityVM.learnerM.freezeCount, singular: "Day Frozen", plural: "Days Frozen")
                     
                            }//HStack - For Cube, Count, and Text
                        }//ZStack - For Freeze Overlaping
                    }//HStack - For Streak and Freeze Count
                    
                }
                .padding(.horizontal)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .animation(.easeInOut, value: calendarVM.showMonthPicker)
    }

    
    // MARK: - Helper
    private func backgroundColor(for day: Day) -> Color {
        if day.isCurrent { return (activityVM.isLogButtonDisabled ? (activityVM.didUseFreezeToday ? .freezePrimaryButton : .streakBG ) : .currentDayCalendar) }
        if day.isLogged { return .streakBG }
        if day.isFreezed { return .freezeBG }
        return .clear
    }
    private func foregroundColor(for: Day) -> Color {
        if `for`.isCurrent { return (activityVM.isLogButtonDisabled ? (activityVM.didUseFreezeToday ? .cubeBlue : .flameOranage) : .white) }
        if `for`.isLogged { return .flameOranage }
        if `for`.isFreezed { return .cubeBlue }
        return .white
    }
}

