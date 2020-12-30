//
//  OnboardingPageTwo.swift
//  Environmentalists
//
//  Created by Ian Campbell on 12/29/20.
//

import SwiftUI

struct OnboardingPageTwo: View {
    var body: some View {
        VStack {
            Image("Second")
                .resizable()
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/2)
            Group {
                Text("Make Your Voice Heard")
                    .font(.title)
                    .allowsTightening(true)
                    .lineLimit(2)
                    .fixedSize(horizontal: true, vertical: false)
                    .minimumScaleFactor(0.9)
                Text("Greenhouse emissions are contributing to irreverisble damage to our planet. It is our duty to make sure this planet can be enjoyed for generations to come.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(width: UIScreen.main.bounds.size.width*4/5, height: UIScreen.main.bounds.size.height/7, alignment: .leading)
            }
            Spacer()
            
        }.edgesIgnoringSafeArea(.all)

    }
}

struct OnboardingPageTwo_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageTwo()
    }
}
