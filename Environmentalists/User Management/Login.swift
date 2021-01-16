//
//  Login.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/3/20.
//

import SwiftUI

struct Login: View {
    
    @EnvironmentObject var sessionManager: UserSessionManager
    
    @State var email = ""
    @State var password = ""
    @State var showPassword = false
    
    var body: some View {
        
        VStack {
            
            Text("Sign In")
                .font(.largeTitle)
                .foregroundColor(Color.white)
                .fontWeight(.medium)
                .padding(.top, 20)
                .padding(.bottom, 25)
            
            VStack {
                    
                    HStack(alignment: .center, spacing: 15) {
                        
                        Image(systemName: "person").opacity(0.5)
                        TextField("Enter Email", text: $email).disableAutocorrection(true)
                
                        
                    }.padding(.horizontal, 25).frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height / 20).background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).clipShape(Capsule()).padding(.bottom, 7.5)
                    
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
                        
                    }.padding(.horizontal, 25).frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height / 20).background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).clipShape(Capsule())

                
                HStack {
                    
                    Spacer()
                    
                    Button("Forgot Password?", action: {
                        sessionManager.authState = .forgotPassword
                    }).padding(.trailing, 15)
                    
                }
                
                VStack {
                    
                    Button("Login", action: {
                        sessionManager.signInWithFirebase(email: email, password: password)
                    }).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width - 100, height: UIScreen.main.bounds.size.height / 15).background(Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))).clipShape(Capsule()).padding(.top,50)
                    
                    HStack {
                        
                        Button("Sign Up", action: {sessionManager.showSignUp()}).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width - 100, height: UIScreen.main.bounds.size.height / 15).background(Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))).clipShape(Capsule())
                        
                    }.padding(.top, 25)
                    
                    Spacer()
                }
                
            }
            
        }.padding(.top, UIScreen.main.bounds.size.height/6).background(LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0, green: 0.1157108322, blue: 0.5436113477, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.50462991, blue: 0, alpha: 1))]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        .alert(isPresented: self.$sessionManager.alert) {
            Alert(title: Text("Sign In Error"), message: Text(self.sessionManager.errorMessage), dismissButton: .destructive(Text("OK")))
        }

    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
