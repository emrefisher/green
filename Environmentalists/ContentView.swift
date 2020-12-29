//
//  ContentView.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/2/20.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var userSessionManager = UserSessionManager()
    
    init() {
        userSessionManager.getCurrentAuthUser()
    }
    
    var body: some View {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
