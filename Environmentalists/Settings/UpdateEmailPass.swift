//
//  Update Email and Password.swift
//  Environmentalists
//
//  Created by Jess Hanf on 2/5/21.
//

import SwiftUI

struct UpdateEmailPass: View {
    
    @EnvironmentObject var sessionManager: UserSessionManager
    @State private var email = ""
    
    var body: some View {
        VStack {
            
            HStack {
                
                Spacer()
            }.padding(.leading, 25.0)
            Text("Update Email and Password")
                .font(.headline)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.vertical, 20.0)
            Text("Provide your information below to change the email and/or password to your Environmend Account")
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding(.horizontal, 30.0)
                .padding(.bottom, 25.0)
            TextField("Email", text: self.$email).padding(.horizontal, 25)
                .disableAutocorrection(true)
                .padding(.horizontal, 25).frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height / 20).background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))).clipShape(Capsule()).padding(.bottom, 7.5)
            Button(action: {
                self.sessionManager.resetPassword(email: email)
            }) {
                Text("Update Password")
                    
            }.padding()
            
            Button(action: {
                self.sessionManager.resetPassword(email: email)
                
            }) {
                
                
        
                Text("Update Email")
           
            }.padding()
            
            Spacer()
        }
        .alert(isPresented: self.$sessionManager.alert) {
            Alert(title: Text("Password Reset Error"), message: Text(self.sessionManager.errorMessage), dismissButton: .destructive(Text("OK")))
            
            
            
        }
    }
}

struct UpdateEmailPass_Previews: PreviewProvider {
    static var previews: some View {
       UpdateEmailPass() .environmentObject(UserSessionManager())
    }
}
