////
////  Welldone.swift
////  LearningJourney
////
////  Created by Farah Almozaini on 28/10/2025.
////
//
//import SwiftUI
//
//struct WelldoneView: View {
//    @StateObject private var vm = LearningViewModel()
//    @State private var showCalendar = false
//    @State private var showGoal = false
//    @State private var showCompletionView = false
//
//    private let headerFontSize: CGFloat = 32
//    private let capsuleHeight: CGFloat = 69
//    private let capsuleWidth: CGFloat = 160
//
//    @State var topic: String
//    @State var period: String
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                LinearGradient(
//                    gradient: Gradient(colors: [
//                        Color.black,
//                        Color(red: 0.05, green: 0.03, blue: 0.02)
//                    ]),
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
//                .ignoresSafeArea()
//
//                VStack(alignment: .leading, spacing: 25) {
//                    headerView
//                    mainCardView
//
//                    if showCompletionView {
//                        completionView
//                    } else {
//                        learnedTodayView
//                    }
//
//                    Spacer()
//                }
//            }
//            .onAppear {
//                vm.moveToCurrentWeek()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    vm.currentDate = Date()
//                }
//                showCompletionView = false
//                checkGoalCompletion()
//            }
//            .fullScreenCover(isPresented: $showCalendar) {
//                CalendarView(vm: vm)
//                    .preferredColorScheme(.dark)
//            }
//            .fullScreenCover(isPresented: $showGoal) {
//                Goul(topic: $topic, period: $period)
//                    .preferredColorScheme(.dark)
//            }
//            .onChange(of: vm.learning.daysLearned) { _ in
//                checkGoalCompletion()
//            }
//        }
//    }
//
//    private func checkGoalCompletion() {
//        let targetDays: Int
//        switch period.lowercased() {
//        case "week": targetDays = 7
//        case "month": targetDays = 30
//        case "year": targetDays = 365
//        default: targetDays = 7
//        }
//
//        if vm.learning.daysLearned >= targetDays {
//            withAnimation(.easeInOut(duration: 0.4)) {
//                showCompletionView = true
//            }
//        }
//    }
//
//    private var completionView: some View {
//        VStack(spacing: 12) {
//            Spacer()
//
//            Image(systemName: "hands.clap.fill")
//                .font(.system(size: 40))
//                .foregroundColor(Color(hex: "#FF9230"))
//                .shadow(color: .orange.opacity(0.4), radius: 10, y: 5)
//                .padding(.bottom, 4)
//
//            Text("Well done!")
//                .font(.system(size: 22, weight: .bold))
//                .foregroundColor(.white)
//
//            Text("Goal completed! Start learning again or\nset new learning goal.")
//                .font(.system(size: 18))
//                .foregroundColor(.gray)
//                .multilineTextAlignment(.center)
//                .fixedSize(horizontal: false, vertical: true)
//                .padding(.horizontal, 30)
//                .padding(.top, -2)
//
//            Spacer(minLength: 60)
//
//            Button {
//                withAnimation { showGoal = true }
//            } label: {
//                Text("Set new learning goal")
//                    .font(.system(size: 18, weight: .semibold))
//                    .foregroundColor(.white)
//                    .frame(width: 250, height: 48)
//                    .background(
//                        RoundedRectangle(cornerRadius: 25)
//                            .fill(Color(hex: "#AF4402"))
//                    )
//            }
//            .shadow(color: .orange.opacity(0.4), radius: 8, y: 4)
//
//            Button {
//                withAnimation {
//                    vm.learning.daysLearned = 0
//                    showCompletionView = false
//                }
//            } label: {
//                Text("Set same learning goal and duration")
//                    .font(.system(size: 15))
//                    .foregroundColor(Color(hex: "#FF9230"))
//            }
//            .padding(.top, 6)
//
//            Spacer()
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.bottom, 40)
//        .transition(.opacity.combined(with: .scale))
//    }
//
//    private var headerView: some View {
//        HStack {
//            Text("Activity")
//                .font(.system(size: headerFontSize, weight: .bold))
//                .foregroundColor(.white)
//
//            Spacer()
//
//            HStack(spacing: 16) {
//                glassEffectButton(icon: "calendar") {
//                    withAnimation(.easeInOut) { showCalendar = true }
//                }
//
//                glassEffectButton(icon: "pencil.and.outline") {
//                    withAnimation(.easeInOut) { showGoal = true }
//                }
//            }
//        }
//        .padding(.horizontal, 25)
//        .padding(.top, 20)
//    }
//
//    private func glassEffectButton(icon: String, action: @escaping () -> Void) -> some View {
//        Button(action: action) {
//            ZStack {
//                Circle()
//                    .fill(
//                        LinearGradient(
//                            gradient: Gradient(colors: [
//                                Color.white.opacity(0.15),
//                                Color.white.opacity(0.05)
//                            ]),
//                            startPoint: .topLeading,
//                            endPoint: .bottomTrailing
//                        )
//                    )
//                    .overlay(
//                        Circle()
//                            .stroke(
//                                LinearGradient(
//                                    colors: [
//                                        Color.white.opacity(0.4),
//                                        Color.white.opacity(0.05)
//                                    ],
//                                    startPoint: .topLeading,
//                                    endPoint: .bottomTrailing
//                                ),
//                                lineWidth: 1.2
//                            )
//                    )
//
//                Image(systemName: icon)
//                    .font(.system(size: 18, weight: .semibold))
//                    .foregroundColor(.white)
//            }
//            .frame(width: 46, height: 46)
//        }
//        .buttonStyle(.plain)
//    }
//
//    private var mainCardView: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            HStack {
//                Button(action: { withAnimation { vm.showMonthPicker.toggle() } }) {
//                    HStack(spacing: 6) {
//                        Text(vm.currentMonthYear)
//                            .font(.system(size: 18, weight: .medium))
//                            .foregroundColor(.white)
//
//                        Image(systemName: "chevron.forward")
//                            .font(.system(size: 14, weight: .bold))
//                            .foregroundColor(Color(hex: "#FF9230"))
//                            .rotationEffect(.degrees(vm.showMonthPicker ? 90 : 0))
//                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: vm.showMonthPicker)
//                    }
//                }
//
//                Spacer()
//
//                HStack(spacing: 20) {
//                    Button(action: { vm.changeWeek(by: -1) }) {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(Color(hex: "#FF9230"))
//                    }
//
//                    Button(action: { vm.changeWeek(by: 1) }) {
//                        Image(systemName: "chevron.right")
//                            .foregroundColor(Color(hex: "#FF9230"))
//                    }
//                }
//            }
//
//            if vm.showMonthPicker {
//                monthYearPicker
//            } else {
//                weekView
//            }
//
//            Divider().background(Color.gray.opacity(0.3))
//
//            Text("Learning \(topic)")
//                .font(.system(size: 18, weight: .semibold))
//                .foregroundColor(.white)
//                .padding(.top, 6)
//
//            HStack(spacing: 18) {
//                capsuleView(
//                    bgColor: Color(hex: "#4A3422"),
//                    icon: "flame.fill",
//                    iconColor: Color(hex: "#FF9230"),
//                    value: vm.learning.daysLearned,
//                    label: (vm.learning.daysLearned <= 1) ? "Day Learned" : "Days Learned"
//                )
//
//                capsuleView(
//                    bgColor: Color(hex: "#243C46"),
//                    icon: "cube.fill",
//                    iconColor: Color(hex: "#77C9D4"),
//                    value: vm.learning.daysFreezed,
//                    label: (vm.learning.daysFreezed <= 1) ? "Day Freezed" : "Days Freezed"
//                )
//            }
//        }
//        .padding(20)
//        .background(
//            RoundedRectangle(cornerRadius: 18)
//                .fill(Color(hex: "#121212"))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 18)
//                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
//                )
//        )
//        .padding(.horizontal, 25)
//    }
//
//    private var weekView: some View {
//        HStack(spacing: 14) {
//            ForEach(vm.currentWeek, id: \.self) { day in
//                VStack(spacing: 6) {
//                    Text(vm.weekday(for: day))
//                        .font(.system(size: 11, weight: .medium))
//                        .foregroundColor(.gray)
//
//                    Text("\(Calendar.current.component(.day, from: day))")
//                        .font(.system(size: 16, weight: .semibold))
//                        .foregroundColor(vm.weekDayTextColor(for: day))
//                        .frame(width: 36, height: 36)
//                        .background(Circle().fill(vm.weekDayBackgroundColor(for: day)))
//                }
//            }
//        }
//    }
//
//    private var monthYearPicker: some View {
//        HStack(spacing: 0) {
//            Picker("Month", selection: $vm.selectedMonth) {
//                ForEach(1...12, id: \.self) { month in
//                    Text(vm.monthName(for: month))
//                        .foregroundColor(.white)
//                        .tag(month)
//                }
//            }
//            .frame(maxWidth: .infinity)
//            .pickerStyle(.wheel)
//            .clipped()
//
//            Picker("Year", selection: $vm.selectedYear) {
//                ForEach(2020...2030, id: \.self) { year in
//                    Text(String(year))
//                        .foregroundColor(.white)
//                        .tag(year)
//                }
//            }
//            .frame(maxWidth: .infinity)
//            .pickerStyle(.wheel)
//            .clipped()
//        }
//        .frame(height: 160)
//        .background(Color.black.opacity(0.001))
//        .cornerRadius(16)
//        .padding(.horizontal, 10)
//    }
//
//    private func capsuleView(bgColor: Color, icon: String, iconColor: Color, value: Int, label: String) -> some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 30)
//                .fill(bgColor)
//                .frame(width: capsuleWidth, height: capsuleHeight)
//
//            HStack(spacing: 10) {
//                Image(systemName: icon)
//                    .font(.system(size: 18))
//                    .foregroundColor(iconColor)
//                VStack(alignment: .leading, spacing: 2) {
//                    Text("\(value)")
//                        .font(.system(size: 24, weight: .bold))
//                        .foregroundColor(.white)
//                    Text(label)
//                        .font(.system(size: 13))
//                        .foregroundColor(.white)
//                }
//            }
//            .padding(.horizontal, 20)
//        }
//    }
//
//    private var learnedTodayView: some View {
//        VStack(spacing: 25) {
//            Spacer()
//
//            ZStack {
//                Circle()
//                    .fill(circleFillStyle)
//                    .overlay(Circle().strokeBorder(circleStrokeStyle, lineWidth: 2))
//                    .frame(width: 274, height: 274)
//
//                VStack(spacing: 5) {
//                    switch vm.currentState {
//                    case .logAsLearned: Text("Log as"); Text("Learned")
//                    case .learnedToday: Text("Learned"); Text("Today")
//                    case .dayFreezed: Text("Day"); Text("Freezed")
//                    }
//                }
//                .font(.system(size: 37, weight: .bold))
//                .foregroundColor(circleTextColor)
//            }
//            .onTapGesture {
//                withAnimation(.easeInOut(duration: 0.3)) {
//                    if vm.currentState == .logAsLearned {
//                        vm.currentState = .learnedToday
//                        vm.markTodayAsLearned()
//                    }
//                }
//            }
//
//            Button {
//                withAnimation(.easeInOut(duration: 0.3)) {
//                    vm.currentState = .dayFreezed
//                    vm.markTodayAsFreezed()
//                }
//            } label: {
//                Text("Log as Freezed")
//                    .font(.system(size: 19, weight: .semibold))
//                    .foregroundColor(.white)
//                    .frame(width: 250, height: 48)
//                    .background(
//                        RoundedRectangle(cornerRadius: 25)
//                            .fill(vm.freezeButtonColor)
//                    )
//            }
//            .disabled(!vm.isFreezeButtonEnabled)
//
//            Text("\(vm.learning.daysFreezed) out of \(vm.learning.totalFreezes) \((vm.learning.daysFreezed <= 1) ? "Freeze used" : "Freezes used")")
//                .font(.system(size: 14))
//                .foregroundColor(.gray.opacity(0.8))
//                .multilineTextAlignment(.center)
//
//            Spacer()
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.horizontal)
//    }
//
//    private var circleFillStyle: AnyShapeStyle {
//        switch vm.currentState {
//        case .logAsLearned:
//            return AnyShapeStyle(LinearGradient(
//                gradient: Gradient(colors: [Color(hex:  "#B24500"), Color(hex: "#FF9230").opacity(0.4)]),
//                startPoint: .topLeading, endPoint: .bottomTrailing
//            ))
//        case .learnedToday:
//            return AnyShapeStyle(LinearGradient(
//                gradient: Gradient(colors: [Color(hex: "#150000"), Color(hex: "#4C311A").opacity(0.4)]),
//                startPoint: .topLeading, endPoint: .bottomTrailing
//            ))
//        case .dayFreezed:
//            return AnyShapeStyle(Color(hex: "#00060C"))
//        }
//    }
//
//    private var circleStrokeStyle: AnyShapeStyle {
//        switch vm.currentState {
//        case .logAsLearned:
//            return AnyShapeStyle(LinearGradient(
//                gradient: Gradient(colors: [Color(hex: "#FF9230").opacity(0.6), Color.clear]),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            ))
//        case .learnedToday:
//            return AnyShapeStyle(LinearGradient(
//                gradient: Gradient(colors: [Color(hex: "#4C311A"), Color.clear]),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            ))
//        case .dayFreezed:
//            return AnyShapeStyle(Color(hex: "#00D2E0"))
//        }
//    }
//
//    private var circleTextColor: Color {
//        switch vm.currentState {
//        case .logAsLearned: return .white
//        case .learnedToday: return Color(hex: "#FF9230")
//        case .dayFreezed: return Color(hex: "#00D2E0")
//        }
//    }
//}
//
//#Preview {
//    ContentView3(topic: "Swift", period: "Week")
//}
