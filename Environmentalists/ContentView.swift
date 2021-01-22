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
    @State var offset: CGFloat = 450
    @State var timer: Timer?
    
    init() {
        userSessionManager.getCurrentAuthUser()
        if hasOnboarded == false && userSessionManager.authState == .session {
            userSessionManager.signOut()
        }
    }
    
    var body: some View {
        
        ZStack {
            
            VStack {
                switch userSessionManager.authState {
                case .session:
                    SessionView()
                        .environmentObject(userSessionManager)
                case .login:
                    ZStack {
                        Image("TestBackground")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .edgesIgnoringSafeArea(.all)
                            .offset(x: self.offset)
                        Login()
                            .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height / 2)
                            .environmentObject(userSessionManager)
                    }.onAppear() {
                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.0001, repeats: true) { timer in
                            self.offset -= 0.005
                            if self.offset <= -575 {
                                self.offset = 450
                            }
                            
                        }
                    }
                    .onDisappear() {
                        self.timer?.invalidate()
                    }
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
