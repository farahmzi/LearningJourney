//
//  ChangeLearningGoalView.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 28/10/2025.

import SwiftUI

struct ChangeLearningGoalView: View {
    @ObservedObject var activityVM: ActivityViewModel
    @ObservedObject var calendarVM: CalendarViewModel

    // نسخة قابلة للتحرير محلياً
    @State private var subject: String
    @State private var selectedDuration: LearnerModel.Duration
    @Environment(\.dismiss) private var dismiss
    @State private var showConfirm = false

    init(activityVM: ActivityViewModel, calendarVM: CalendarViewModel) {
        self.activityVM = activityVM
        self.calendarVM = calendarVM
        // تهيئة الـ State من القيم الحالية
        _subject = State(initialValue: activityVM.learnerM.subject)
        _selectedDuration = State(initialValue: activityVM.learnerM.duration)
    }

    private var hasChanges: Bool {
        subject.trimmingCharacters(in: .whitespacesAndNewlines) != activityVM.learnerM.subject ||
        selectedDuration != activityVM.learnerM.duration
    }

    // عرض فوري لعدد الفريز حسب الاختيار الحالي
    private var previewFreezeLimit: Int {
        switch selectedDuration {
        case .week:  return 2
        case .month: return 8
        case .year:  return 96
        }
    }

    var body: some View {
        ZStack {
            // المحتوى الأساسي
            VStack(alignment: .leading, spacing: 24) {
                Group {
                    Text("I want to learn")
                        .font(.system(size: 22))
                    TextField("Swift", text: $subject)
                        .font(.system(size: 17))
                        .foregroundColor(.gray)
                    Divider()
                }

                Group {
                    Text("I want to learn it in a")
                        .font(.system(size: 22))
                    HStack(spacing: 12) {
                        ForEach(LearnerModel.Duration.allCases) { duration in
                            Button {
                                selectedDuration = duration
                            } label: {
                                Text(duration.rawValue.capitalized)
                                    .frame(width: 97, height: 48)
                                    .glassEffect(.clear.interactive())
                                    .background(selectedDuration == duration ? Color(.primaryButton) : Color.clear)
                                    .cornerRadius(30)
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // سطر يوضح عدد الفريز المتوقع حسب الاختيار الحالي
                    Text("\(previewFreezeLimit) Freezes will be available for this period")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Learning Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showConfirm = true
                    } label: {
                        ZStack {
                            // دائرة برتقالية ممتلئة بالكامل
                            Circle()
                                .fill(Color(.primaryButton))
                                .frame(width: 44, height: 44)

                            // أيقونة الصح باللون الأبيض
                            Image(systemName: "checkmark")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(width: 44, height: 44)
                    // التعطيل يمنع التفاعل فقط، اللون يبقى برتقالي كما طلبتِ
                    .disabled(!hasChanges || subject.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }

            // بطاقة التأكيد كـ "رت" مخصص
            if showConfirm {
                ConfirmCard(
                    title: "Update Learning goal",
                    message: "If you update now, your streak will start over.",
                    dismissTitle: "Dismiss",
                    confirmTitle: "Update",
                    onDismiss: { withAnimation(.spring(response: 0.28, dampingFraction: 0.95)) { showConfirm = false } },
                    onConfirm: {
                        applyChangesAndResetProgress()
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.95)) {
                            showConfirm = false
                        }
                        dismiss()
                    }
                )
                .transition(.scale(scale: 0.96).combined(with: .opacity))
                .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showConfirm)
    }

    private func applyChangesAndResetProgress() {
        // حدّث نموذج المتعلم
        activityVM.learnerM.subject = subject.trimmingCharacters(in: .whitespacesAndNewlines)
        activityVM.learnerM.duration = selectedDuration
        activityVM.learnerM.startDate = Date()

        // صفّر التقدّم والأزرار
        activityVM.resetForNewGoal()
        // لا نضبط freezeLimit يدويًا هنا — resetForNewGoal() يستدعي setupFreezeLimit()
        // والتي تستخدم selectedDuration.defaultFreezeLimit لضمان الاتساق

        // حدّث تقويم العرض ليعكس الموضوع/التواريخ الجديدة
        calendarVM.learnerM = activityVM.learnerM
        calendarVM.setMonth(Date())
    }
}

// MARK: - Confirm Card (رت)
private struct ConfirmCard: View {
    var title: String
    var message: String
    var dismissTitle: String
    var confirmTitle: String
    var onDismiss: () -> Void
    var onConfirm: () -> Void

    @State private var appear = false

    var body: some View {
        ZStack {
            // خلفية مع تمويه خفيف ولمسة dim
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)

            // البطاقة
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)

                Text(message)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.85))
                    .padding(.bottom, 8)

                HStack(spacing: 12) {
                    // زر Dismiss زجاجي رمادي
                    Button(action: onDismiss) {
                        Text(dismissTitle)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 48)
                    }
                    .buttonStyle(.plain)
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color.clear)
                            .glassEffect(.regular.interactive().tint(.gray.opacity(0.18)))
                    )

                    // زر Update برتقالي ممتلئ
                    Button(action: onConfirm) {
                        Text(confirmTitle)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 48)
                    }
                    .buttonStyle(.plain)
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color(.primaryButton))
                            .shadow(color: Color(.primaryButton).opacity(0.35), radius: 10, x: 0, y: 4)
                    )
                }
                .padding(.top, 4)
            }
            .padding(16)
            .frame(maxWidth: 320)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.black.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
                    )
                    .shadow(color: .black.opacity(0.6), radius: 24, x: 0, y: 10)
                    .shadow(color: .white.opacity(0.06), radius: 2, x: 0, y: -1) // لمسة inner-ish
            )
            .scaleEffect(appear ? 1 : 0.96)
            .opacity(appear ? 1 : 0)
            .onAppear {
                withAnimation(.spring(response: 0.28, dampingFraction: 0.95)) {
                    appear = true
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
    }
}

#Preview {
    // نموذج بيانات للتجربة
    let sampleLearner = LearnerModel(
        subject: "Swift",
        duration: .month,
        startDate: Date(),
        streak: 5,
        freezeCount: 2,
        freezeLimit: LearnerModel.Duration.month.defaultFreezeLimit
    )
    let activityVM = ActivityViewModel(learnerM: sampleLearner)
    let calendarVM = CalendarViewModel(learnerM: sampleLearner)

    return NavigationStack {
        ChangeLearningGoalView(activityVM: activityVM, calendarVM: calendarVM)
    }
    .preferredColorScheme(.dark)
}
