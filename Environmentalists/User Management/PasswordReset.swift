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
            }.padding(.leading, 25.0)
            Text("Reset Password")
                .font(.headline)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.trailing, 250.0)
                .padding(.vertical, 20.0)
            Text("Provide your information below to change the password to your Environmend Account")
                .lineLimit(nil)
                .padding(.trailing, 30.0)
                .padding(.bottom, 25.0)
            TextField("Email", text: self.$email).padding(.horizontal, 25)
                .disableAutocorrection(true)
                .padding(.horizontal, 25).frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height / 20).background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))).clipShape(Capsule()).padding(.bottom, 7.5)
            Button(action: {
                self.sessionManager.resetPassword(email: email)
            }) {
                Text("Reset Password")
            }
            
            Spacer()
            
            
        }
        .alert(isPresented: self.$sessionManager.alert) {
            Alert(title: Text("Password Reset Error"), message: Text(self.sessionManager.errorMessage), dismissButton: .destructive(Text("OK")))
        }
    }
}

struct PasswordReset_Previews: PreviewProvider {
    static var previews: some View {
       PasswordReset() .environmentObject(UserSessionManager())
    }
}
