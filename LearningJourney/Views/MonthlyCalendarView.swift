//
//  MonthlyCalendarView.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 27/10/2025.
//

import SwiftUI

struct MonthlyCalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    var body: some View {
        VStack {
            
            HStack {
                Text(viewModel.selectedMonth, format: .dateTime.month().year())
                    .font(.title)
                    .bold()
                Spacer()
                
            }
            .padding()
            
            LazyVGrid(columns: columns) {
                ForEach(viewModel.weekDays, id: \.self) { day in
                    Text(day)
                }
                
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
