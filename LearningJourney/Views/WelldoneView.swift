//
//  Welldone.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 28/10/2025.
//

import SwiftUI
import SwiftData

struct Welldone: View {
    @State var navigate: Bool = false
    
    var body: some View {
        VStack(spacing: 8){
            
            Image(systemName: "hands.and.sparkles.fill")
                .frame(width: 41, height: 41)
                .foregroundStyle(.currentDayCalendar)
                .font(.system(size: 40))
                .padding(.top, 62)
            
            VStack (spacing: 4){
                Text("Well done!").font(.title2).bold()
                Text("Goal completed! start learning again\nor set new learning goal")
                    .multilineTextAlignment(.center)
                    .font(.system(size:18, weight: .medium))
                    .lineHeight(.leading(increase: 10))
                .foregroundStyle(.gray)}
            Spacer()
            
            Button{
                navigate = true
            } label: {
                Text("Set new learning goal")
                    .padding(14)
                    .font(.footnote)
                    .glassEffect(.clear.interactive().tint(.currentDayCalendar))
            }.buttonStyle(.plain)
            
            
            Text("Set same learning goal and duration")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.currentDayCalendar)
                .onTapGesture {
                    
                    
                }.padding(.top, 8)
        }.navigationDestination(isPresented: $navigate) {
            Text("Navigated")
        }
    }
}

#Preview {
    
    Welldone()
}
