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
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/2)
                .clipped()
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
                Text("Get Started").font(.title).foregroundColor(.black)
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
