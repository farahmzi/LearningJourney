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
    
    // بدّلنا التوقيع ليمرّر LearnerModel النهائي
    var onFinished: (LearnerModel) -> Void = { _ in }
    
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
                        
                    TextField("Swift", text: $onboardingVM.subject)
                        .font(.system(size: 17))
                        .foregroundColor(.gray)
                    Divider()
                    Text("I want to learn it in a ")
                        .font(.system(size: 22))
                        .padding(.top, 20)
                    HStack{
                        ForEach(LearnerModel.Duration.allCases) { duration in
                            Button {
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
                        }
                    }
                Spacer()
                }
                .padding(.top, 40)
                Button{
                    onboardingVM.createLearner()
                    // مرّرنا الـ learner النهائي للروت
                    onFinished(onboardingVM.learner)
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
              
            }
            .padding()
    }
}
#Preview {
    OnboardingView { _ in }
}
