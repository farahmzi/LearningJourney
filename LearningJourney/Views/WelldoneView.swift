//
//  Welldone.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 28/10/2025.
//

import SwiftUI
import SwiftData

struct Welldone: View {
    // إغلاق يُستدعى عند الضغط على زر القلم أو زر "Set new learning goal"
    // ActivityView يمرره لفتح صفحة ChangeLearningGoalView
    var onEditTapped: (() -> Void)? = nil
    
    // لم نعد نستخدم التنقل الداخلي هنا لأن ActivityView يتكفّل بالتنقل
    @State var navigate: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            // زر القلم أعلى الواجهة لتعديل الهدف
            HStack {
                Spacer()
                Button {
                    onEditTapped?()
                } label: {
                    Image(systemName: "pencil.and.outline")
                        .font(.system(size: 22))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive().tint(.gray.opacity(0.1)))
            }
            
            // أيقونة التهنئة
            Image(systemName: "hands.and.sparkles.fill")
                .frame(width: 41, height: 41)
                .foregroundStyle(.currentDayCalendar)
                .font(.system(size: 40))
                .padding(.top, 18)
            
            // نصوص التهنئة والتوضيح
            VStack (spacing: 4) {
                Text("Well done!").font(.title2).bold()
                Text("Goal completed! start learning again\nor set new learning goal")
                    .multilineTextAlignment(.center)
                    .font(.system(size:18, weight: .medium))
                    .lineHeight(.leading(increase: 10))
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            // زر لبدء إعداد هدف جديد (يفتح نفس صفحة التغيير)
            Button {
                onEditTapped?()
            } label: {
                Text("Set new learning goal")
                    .padding(14)
                    .font(.footnote)
                    .glassEffect(.clear.interactive().tint(.currentDayCalendar))
            }
            .buttonStyle(.plain)
            
            // ملاحظة: يمكن لاحقًا جعل هذا يعيد تشغيل نفس الهدف مباشرة
            Text("Set same learning goal and duration")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.currentDayCalendar)
                .padding(.top, 8)
        }
    }
}

#Preview {
    Welldone()
}

