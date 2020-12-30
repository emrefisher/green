//
//  OnboardingPageOne.swift
//  Environmentalists
//
//  Created by Ian Campbell on 12/29/20.
//

import SwiftUI

struct OnboardingPageOne: View {
    var body: some View {
        
        
        VStack {
            Image("First")
                .resizable()
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/2)
            Group {
                Text("Welcome to Environmend!")
                    .font(.title)
                    .allowsTightening(true)
                    .lineLimit(2)
                    .fixedSize(horizontal: true, vertical: false)
                    .minimumScaleFactor(0.9)
                Text("Here at Environmend we believe that YOU are the change this world needs. Are you ready to do your part to save our planet?")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(width: UIScreen.main.bounds.size.width*4/5, height: UIScreen.main.bounds.size.height/7, alignment: .leading)
            }
            Spacer()
            
        }.edgesIgnoringSafeArea(.all)

     }
 }

 struct ButtonContent: View {
     var body: some View{
         Image(systemName: "arrow.right")
             .resizable()
             .foregroundColor(.white)
             .frame(width: UIScreen.main.bounds.size.width/10, height: UIScreen.main.bounds.size.height/20)
             .padding()
             .background(Color.black)
             .cornerRadius(UIScreen.main.bounds.size.width/10)
             .offset(y: UIScreen.main.bounds.size.height/(-25))
     }
 }

 struct GetStartedButton: View {
     var body: some View{
         Text("Get Started")
             .foregroundColor(.white)
             .frame(width: UIScreen.main.bounds.size.width*4/10, height: UIScreen.main.bounds.size.width/10)
             //.padding()
             .background(Color.black)
             .cornerRadius(UIScreen.main.bounds.size.width/10)
             .offset(x: UIScreen.main.bounds.size.width/(-20), y: UIScreen.main.bounds.size.height/(-30))
     }
}

struct OnboardingPageOne_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageOne()
    }
}
