//
//  ActivityView.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 27/10/2025.

import SwiftUI

struct ActivityView: View {
    // نستخدم StateObject لأن الـ View هو المالك للـ ViewModel ويحتاج يحتفظ بحالته
    @StateObject var activityVM: ActivityViewModel
    @StateObject var calendarVM: CalendarViewModel
    
    // حالات تحكّم بالتنقل داخل NavigationStack
    @State private var showCalendar = false
    @State private var showOnboarding = false
    @State private var showChangeGoal = false
    
    // مُهيّئ يستقبل نموذج المتعلّم ويهيّئ الـ ViewModels
    init(learnerM: LearnerModel) {
        _activityVM = StateObject(wrappedValue: ActivityViewModel(learnerM: learnerM))
        _calendarVM = StateObject(wrappedValue: CalendarViewModel(learnerM: learnerM))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // شريط علوي: عنوان الصفحة + أزرار الأدوات
                HStack {
                    Text("Activity")
                        .font(.system(size: 34))
                        .bold()
                    Spacer()
                    Group {
                        // زر فتح التقويم
                        Button {
                            showCalendar = true
                        } label: {
                            Image(systemName: "calendar")
                        }
                        // زر تعديل هدف التعلّم
                        Button {
                            showChangeGoal = true
                        } label: {
                            Image(systemName: "pencil.and.outline")
                        }
                    }
                    .buttonStyle(.plain)
                    .font(.system(size: 22))
                    .frame(width: 44, height: 44)
                    .glassEffect(.regular.interactive().tint(.gray.opacity(0.1)))
                } // HStack
                
                // بطاقة التقويم المصغّر + ملخص الستريك والفريز
                ZStack {
                    VStack(alignment: .leading) {
                        // نمرر نفس الـ ViewModels حتى تكون الحالة موحّدة
                        CompactCalendarView(calendarVM: calendarVM, activityVM: activityVM)
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 12)
                }
                .frame(width: 365, height: 254)
                .padding(.bottom, 25)
                
                // عرض المحتوى بحسب تحقق الهدف من عدمه
                if !activityVM.isAchieved  {
                    // زر تسجيل اليوم كـ "تعلم"
                    Button {
                        activityVM.logAsLearned()
                    } label: {
                        Text(activityVM.didUseFreezeToday
                             ? "Day Freezed" // تم استخدام فريز اليوم
                             : (activityVM.isLogButtonDisabled ? "Learned\nToday" : "Log as\nLearned"))
                            .multilineTextAlignment(.center)
                            .font(.system(size: 36))
                            // تلوين النص حسب الحالة (معطّل/مفعّل + فريز)
                            .foregroundStyle(Color(activityVM.isLogButtonDisabled ? (activityVM.didUseFreezeToday ? .cubeBlue : .flameOranage) : .white))
                            .frame(width: 232, height: 100)
                            .bold()
                    }
                    .disabled(activityVM.isLogButtonDisabled) // يتعطل بعد التسجيل حتى منتصف الليل
                    .buttonStyle(.plain)
                    .frame(width: 274, height: 274)
                    .glassEffect(.clear.interactive().tint(Color(activityVM.isLogButtonDisabled ? (activityVM.didUseFreezeToday ? .dayFreezeBG : .onboardingLogoBG) : .primaryButton)))
                    
                    Spacer()
                    
                    // زر استخدام فريز هذا اليوم
                    Button {
                        activityVM.useFreeze()
                    } label: {
                        Text("Log as freezed")
                    }
                    .disabled(activityVM.isFreezeButtonDisabled) // يتعطل إذا نفدت الفريزات أو بعد الاستخدام حتى منتصف الليل
                    .buttonStyle(.plain)
                    .font(.system(size: 17))
                    .foregroundColor(Color(.white))
                    .frame(width: 274, height: 48)
                    .glassEffect(.regular.interactive().tint(Color(activityVM.didUseFreezeToday ? .disabledLogFreeze : (activityVM.isOutOfFreeze ? .disabledLogFreeze : .freezePrimaryButton))))
                    
                    // توضيح عدد الفريزات المستخدمة من الحد الأقصى
                    Text("\(activityVM.learnerM.freezeCount) out of \(activityVM.learnerM.freezeLimit) freezes used")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.gray))
                } else {
                    // إذا تحقق الهدف: نعرض شاشة التهنئة Welldone
                    // ونمرر إغلاق يفتح صفحة تغيير الهدف عند الضغط على القلم
                    Welldone(onEditTapped: {
                        showChangeGoal = true
                    })
                }
            } // VStack
            .padding()
            .onAppear {
                // تحقق من شرط تصفير الستريك إذا مر وقت طويل بدون تسجيل
                activityVM.checkStreakResetCondition()
            }
            // تعريف الوجهات الملاحية
            .navigationDestination(isPresented: $showCalendar) {
                CalendarView(learnerM: activityVM.learnerM)
            }
            .navigationDestination(isPresented: $showChangeGoal) {
                ChangeLearningGoalView(activityVM: activityVM, calendarVM: calendarVM)
            }
        } // NavigationStack
    } // body
} // struct

// معاينة: مثال هدف أسبوعي يتحقق عند جمع الستريك والفريز = 7
#Preview("Week - 7 days (should achieve)") {
    ActivityView(learnerM: LearnerModel(
        subject: "Swift",
        duration: .week,
        startDate: Date(),
        streak: 5,
        freezeCount: 2,
        freezeLimit: LearnerModel.Duration.week.defaultFreezeLimit
    ))
}

