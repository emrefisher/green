//
//  OnboardingPageThree.swift
//  Environmentalists
//
//  Created by Ian Campbell on 12/29/20.
//

import SwiftUI

struct OnboardingPageThree: View {
    var body: some View {
        VStack {
            Image("Third")
                .resizable()
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/2)
            Group {
                Text("Volunteer")
                    .font(.title)
                    .allowsTightening(true)
                    .lineLimit(2)
                    .fixedSize(horizontal: true, vertical: false)
                    .minimumScaleFactor(0.9)
                Text("In Green Sign-Up you can find a variety of opportunties to help in your community. Every set of hands can make a difference.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(width: UIScreen.main.bounds.size.width*4/5, height: UIScreen.main.bounds.size.height/7, alignment: .leading)
            }
            Spacer()
            
        }.edgesIgnoringSafeArea(.all)
        
    }
}

struct OnboardingPageThree_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageThree()
    }
}
