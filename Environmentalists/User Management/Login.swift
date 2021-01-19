//
//  Login.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/3/20.
//

import SwiftUI

struct Login: View {
    
    @EnvironmentObject var sessionManager: UserSessionManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var frameWidth = UIScreen.main.bounds.width * 0.85
    @State private var frameHeight = UIScreen.main.bounds.height / 2
    
    var body: some View {
        VStack {
            
            Text("Sign In")
                .font(.largeTitle)
                .italic()
                .padding(.bottom, self.frameHeight / 20)
                .padding(.top, self.frameHeight / 7)
            
            VStack(spacing: self.frameWidth / 30) {
                    
                    HStack(alignment: .center, spacing: 15) {
                        
                        Image(systemName: "person").opacity(0.5)
                        TextField("Enter Email", text: $email).disableAutocorrection(true)
                
                        
                    }.padding(.horizontal).frame(width: self.frameWidth * 0.85, height: self.frameHeight / 12.5).background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
                    
                    HStack(alignment: .center, spacing: 15) {
                        
                        Image(systemName: "lock").opacity(0.5)
                        
                        if self.showPassword {
                            TextField("Enter Password", text: $password).disableAutocorrection(true)
                        }
                        else {
                            SecureField("Enter Password", text: $password).disableAutocorrection(true)
                        }
                        
                        
                        Button(action: {
                            
                            self.showPassword.toggle()
                            
                        }) {
                            
                            Image(systemName: self.showPassword ? "eye.fill" : "eye.slash.fill")
                        }
                        
                    }.padding(.horizontal).frame(width: self.frameWidth * 0.85, height: self.frameHeight / 12.5).background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)

                
                HStack {
                    
                    Spacer()
                    
                    Button("Forgot Password?", action: {
                        sessionManager.authState = .forgotPassword
                    })
                    
                }.padding(.trailing, self.frameWidth * 0.05)
                Spacer()
                VStack(spacing: self.frameWidth / 20) {
                    
                    Button(action: {
                        sessionManager.signInWithFirebase(email: self.email, password: self.password)
                    }) {
                        Text("Login").foregroundColor(.white).frame(width: self.frameWidth * 0.6, height: self.frameHeight / 10).background(Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
                    }
                        
                        Button("Don't have an account? Sign Up", action: {
                            sessionManager.authState = .signUp
                        })
                    
                }.padding(.bottom, self.frameHeight / 5)
            }
            
        }.background(RoundedRectangle(cornerRadius: 25.0)
            .fill(Color.white.opacity(0.8))
            .shadow(color: .black, radius: 10, x: 20, y: 20))
        .alert(isPresented: self.$sessionManager.alert) {
            Alert(title: Text("Sign In Error"), message: Text(self.sessionManager.errorMessage), dismissButton: .destructive(Text("OK")))
        }

    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login().environmentObject(UserSessionManager())
    }
}
