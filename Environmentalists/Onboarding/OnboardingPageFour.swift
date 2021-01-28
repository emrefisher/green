//
//  OnboardingPageFour.swift
//  Environmentalists
//
//  Created by Ian Campbell on 12/29/20.
//

import SwiftUI

struct OnboardingPageFour: View {
    
    @Binding var isPresenting: Bool
    
    var body: some View {
        
        VStack {
            Image("Fourth")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height*2/5)
                .clipped()
                .padding(.top, UIScreen.main.bounds.size.height/10)
            Group {
                Text("Let's Save the World")
                    .font(.title)
                    .allowsTightening(true)
                    .lineLimit(2)
                    .fixedSize(horizontal: true, vertical: false)
                    .minimumScaleFactor(0.9)
                Text("Together we can be the difference and promote real change. Find your next volunteer event now!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(width: UIScreen.main.bounds.size.width*4/5, height: UIScreen.main.bounds.size.height/7, alignment: .leading)
            }
            Spacer()
            
            Button(action: {
                self.isPresenting.toggle()
            }) {
                Text("Enter Here").foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*3/5, height: UIScreen.main.bounds.size.height / 10).background(Color(#colorLiteral(red: 0.3803921569, green: 0.768627451, blue: 0.1607843137, alpha: 1))).clipShape(Capsule())
            }.padding(.bottom, 50)
            
            Spacer()
            
        }.edgesIgnoringSafeArea(.all)
    }
}

struct OnboardingPageFour_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageFour(isPresenting: .constant(true))
    }
}
