//
//  PasswordReset.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/3/20.
//

import SwiftUI

struct PasswordReset: View {
    
    @EnvironmentObject var sessionManager: UserSessionManager
    @State private var email = ""
    
    var body: some View {
        VStack {
            
            HStack {
                Button(action: {
                    sessionManager.authState = .login
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                }
                Spacer()
            }.padding(.leading, 25)
            Spacer()
            Text("Password Reset View")
            TextField("Email", text: self.$email).padding(.horizontal, 25)
            Button(action: {
                self.sessionManager.resetPassword(email: email)
            }) {
                Text("Reset Password")
            }
            
            Spacer()
            
            
        }.background(LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0, green: 0.1157108322, blue: 0.5436113477, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.50462991, blue: 0, alpha: 1))]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        .alert(isPresented: self.$sessionManager.alert) {
            Alert(title: Text("Password Reset Error"), message: Text(self.sessionManager.errorMessage), dismissButton: .destructive(Text("OK")))
        }
    }
}

struct PasswordReset_Previews: PreviewProvider {
    static var previews: some View {
        PasswordReset()
    }
}
