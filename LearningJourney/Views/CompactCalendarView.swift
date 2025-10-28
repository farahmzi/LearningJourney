//
//  CompactCalendarView.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 27/10/2025.
//

import SwiftUI

struct CompactCalendarView: View {
    @ObservedObject var calendarVM: CalendarViewModel
    @ObservedObject var activityVM: ActivityViewModel  // not @StateObject anymore
 
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius:13, style: .continuous)
                .fill(Color.gray.opacity(0.25))
                .stroke(Color.gray, lineWidth: 0.5)
                .opacity(0.5)
            VStack(alignment: .leading){
                // استخدم الـ VM الممرّر بدل إنشاء واحد جديد داخل body
                WeeklyCalendarView(calendarVM: calendarVM, activityVM: activityVM)
                    .previewLayout(.sizeThatFits)
            }//VStack - For Calendar, Text, and Counts
        }//ZStack
        .frame(width: 350, height: 254)
    }//body
}//struct
