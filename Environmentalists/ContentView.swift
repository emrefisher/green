//
//  ContentView.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/2/20.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var userSessionManager = UserSessionManager()
    @State private var showOnboarding = false
    @AppStorage("OnboardViewed") var hasOnboarded = false
    
    init() {
        userSessionManager.getCurrentAuthUser()
    }
    
    var body: some View {
        
        ZStack {
            
            VStack {
                switch userSessionManager.authState {
                case .session:
                    SessionView()
                        .environmentObject(userSessionManager)
                case .login:
                    Login()
                        .environmentObject(userSessionManager)
                case .signUp:
                    SignUp()
                        .environmentObject(userSessionManager)
                case .forgotPassword:
                    PasswordReset()
                        .environmentObject(userSessionManager)
                }
            }.disabled(showOnboarding)
            .blur(radius: showOnboarding ? 3.0 : 0)
            
            if showOnboarding {
                OnboardingView(isPresenting: self.$showOnboarding).edgesIgnoringSafeArea(.all)
            }
            
        }.onAppear() {
            if !hasOnboarded {
                DispatchQueue.main.async {
                    withAnimation {
                        showOnboarding.toggle()
                        hasOnboarded = true
                    }
                }
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
