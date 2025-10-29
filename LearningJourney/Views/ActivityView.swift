//
//  ActivityView.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 27/10/2025.
import SwiftUI
struct ActivityView: View {
    @StateObject var activityVM: ActivityViewModel
    @StateObject var calendarVM: CalendarViewModel
    
    @State private var showCalendar = false
    @State private var showOnboarding = false
    @State private var showChangeGoal = false
    //🟥
    init(learnerM: LearnerModel) {
        _activityVM = StateObject(wrappedValue: ActivityViewModel(learnerM: learnerM))
        _calendarVM = StateObject(wrappedValue: CalendarViewModel(learnerM: learnerM))
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Text("Activity")
                        .font(.system(size: 34))
                        .bold()
                    Spacer()
                    Group {
                        Button {
                            showCalendar = true
                        } label: {
                            Image(systemName: "calendar")
                        }
                        
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
                    
                    
                }//HStack - For Title and Tool Bar
                ZStack {
                    VStack(alignment: .leading){
                        CompactCalendarView(calendarVM: calendarVM,activityVM: activityVM)
                    }//VStack - For Calendar, Text, and Counts
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 12)
                }//ZStack - For Background Frame of Calendar and Counts
                .frame(width: 365, height: 254)
                .padding(.bottom, 25)
                Button{
                    activityVM.logAsLearned()
                }
                label: {
                    Text(activityVM.didUseFreezeToday
                         ? "Day Freezed"
                         : (activityVM.isLogButtonDisabled ? "Learned\nToday" : "Log as\nLearned"))
                        .multilineTextAlignment(.center)
                        .font(.system(size: 36))
                        .foregroundStyle(Color(activityVM.isLogButtonDisabled ? (activityVM.didUseFreezeToday ? .cubeBlue : .flameOranage): .white))
                        .frame(width: 232, height: 100)
                        .bold()
                }
                .disabled(activityVM.isLogButtonDisabled)
                .buttonStyle(.plain)
                .frame(width: 274, height: 274)
                .glassEffect(.clear.interactive().tint(Color(activityVM.isLogButtonDisabled ? (activityVM.didUseFreezeToday ? .dayFreezeBG : .onboardingLogoBG): .primaryButton)))
                Spacer()
                Button{
                    activityVM.useFreeze()
                } label: {
                    Text("Log as freezed")
                }
                .disabled(activityVM.isFreezeButtonDisabled)
                .buttonStyle(.plain)
                .font(.system(size: 17))
                .foregroundColor(Color(.white))
                .frame(width: 274, height: 48)
                .glassEffect(.regular.interactive().tint(Color(activityVM.didUseFreezeToday ? .disabledLogFreeze : (activityVM.isOutOfFreeze ? .disabledLogFreeze :.freezePrimaryButton))))
                
                Text("\(activityVM.learnerM.freezeCount) out of \(activityVM.learnerM.freezeLimit) freezes used")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.gray))
                
            }//VStack
            .padding()
            
            .onAppear {
                activityVM.checkStreakResetCondition()
            }
            // Destinations
            .navigationDestination(isPresented: $showCalendar) {
                CalendarView(learnerM: activityVM.learnerM)
            }
            .navigationDestination(isPresented: $showChangeGoal) {
                ChangeLearningGoalView(activityVM: activityVM, calendarVM: calendarVM)
            }
        }//NavigationStack
    }//body
    
}//struct
#Preview {
    
    ActivityView(learnerM: LearnerModel(
        subject: "Swift",
        duration: .month,
        startDate: Date(),
        streak: 3,
        freezeCount: 8,
        freezeLimit: 3
    ))
}
