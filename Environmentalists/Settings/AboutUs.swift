//
//  AboutUs.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/27/20.
//

import SwiftUI

struct AboutUs: View {
    var body: some View {
        
        
        VStack(spacing: 0) {
            Text("About Us").font(.largeTitle)
                .padding(.vertical, UIScreen.main.bounds.size.height / 10)
                .frame(width: UIScreen.main.bounds.size.width)
                .background(Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)))

            VStack {
                Text("Green Sign-Up was built with one goal in mind — to promote environmental activism. Scientists predict that global climate change will cause irreversible damage to our planet within the next 10 years and we hope with this app we can contribute to the cultural shift and sentiment about how we take care of the Earth. Thank you for downloading the app and volunteering your time towards the fight against climate change. Together we can be the difference this world needed.")
                    .padding(.horizontal, 30)
                    .padding(.top, 50)
                    
                Spacer()

            }.frame(width: UIScreen.main.bounds.size.width)
            .background(Color.black.opacity(0.15))
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct AboutUs_Previews: PreviewProvider {
    static var previews: some View {
        AboutUs()
    }
}
