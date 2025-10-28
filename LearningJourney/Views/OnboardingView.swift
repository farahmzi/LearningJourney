//
//  OnboardingView.swift
//  LearningJourney
//
//  Created by Farah Almozaini on 27/10/2025.
//


import SwiftUI
struct OnboardingView: View {
    //Object of the OnboardingViewModel
    @State var onboardingVM = OnboardingViewModel()
    
    var onFinished: () -> Void = {}
    
    var body: some View {
            VStack{
                Image(systemName: "flame.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(Color(.flameOranage))
                    .frame(width: 109, height: 109)
                    .glassEffect(.clear)
                    .background(.onboardingLogoBG)
                    .cornerRadius(100)
                VStack(alignment: .leading){
                    Text("Hello Learner")
                        .font(.system(size: 34))
                        .bold()
                    Text("This app will help you learn everyday!")
                        .font(.system(size: 17))
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                    Text("I want to learn")
                        .font(.system(size: 22))
                        
                    TextField("Swift", text: $onboardingVM.learner.subject)
                        .font(.system(size: 17))
                        .foregroundColor(.gray)
                    Divider()
                    Text("I want to learn it in a ")
                        .font(.system(size: 22))
                        .padding(.top, 20)
                    HStack{
                        //No need for (...id: \.self) anymore — because the enum is Identifiable.
                        ForEach(LearnerModel.Duration.allCases) {
                            duration in Button {
                                onboardingVM.selectDuration(duration)
                            } label: {
                                Text(duration.rawValue.capitalized)
                                    .frame(width: 97, height: 48)
                                    .glassEffect(.clear.interactive())
                                    .background(onboardingVM.selectedDuration == duration ? Color(.primaryButton) : Color.clear)
                                    .cornerRadius(30)
                                    .foregroundColor(.white)
                                }
                                .buttonStyle(.plain)
                        }//ForEach
                    }//HStack - For Buttons
                Spacer()
                }//VStack - For Text Alignment
                .padding(.top, 40)
                Button{
                    onboardingVM.createLearner()
                    onFinished()  // This switches the root view to ActivityView
                }label: {
                    Text("Start learning")
                }
                .buttonStyle(.plain)
                .font(.system(size: 17))
                .foregroundColor(Color(.white))
                .frame(width: 182, height: 48)
                .glassEffect(.clear.interactive())
                .background(.primaryButton)
                .cornerRadius(30)
              
            
            }//VStack
            .padding()
     
        
        
    }//body
}//struct

#Preview {
    OnboardingView()
}
