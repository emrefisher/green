//
//  OnboardingView.swift
//  Environmentalists
//
//  Created by Ian Campbell on 12/29/20.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var onboardingPageIndex = 1
    
    var body: some View {
        
        TabView(selection: self.$onboardingPageIndex) {
            OnboardingPageOne().tabItem {
                Text("1")
            }.tag(1)
            OnboardingPageTwo().tabItem {
                Text("2")
            }.tag(2)
            OnboardingPageThree().tabItem {
                Text("3")
            }.tag(3)
            OnboardingPageFour().tabItem {
                Text("4")
            }.tag(4)
        }.tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
