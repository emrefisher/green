//
//  ActivistSignUpPageTwo.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/28/21.
//

import SwiftUI

struct ActivistSignUpPageTwo: View {
    
    @ObservedObject var activistSignUpManager: ActivistSignUpManager
    @State private var showPassword = false
    @State private var showConfirmedPassword = false
    @State private var errorMessage = ""
    @State private var alert = false
    
    var body: some View {
        VStack (spacing: 30) {
                
                ProgressView(value: CGFloat(self.activistSignUpManager.pageNumber), total: 6) {
                    HStack(alignment: .center) {
                        Text("Progress: (\(self.activistSignUpManager.pageNumber)/6)")
                    }

                }.padding(.top, 85)
                Spacer()
                Text("Choose Password")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                Text("Password must be at least 8 total characters long and must include at least one capital letter and one number.").font(.caption).foregroundColor(.black).padding(.horizontal, 15)
                HStack {
                    
                    if self.showPassword {
                        TextField("Enter Password", text: self.$activistSignUpManager.password).textFieldStyle(RoundedBorderTextFieldStyle()).disableAutocorrection(true)
                            .padding(.horizontal, 15)
                    }
                    else {
                        SecureField("Enter Password", text: self.$activistSignUpManager.password).textFieldStyle(RoundedBorderTextFieldStyle()).disableAutocorrection(true)
                            .padding(.horizontal, 15)
                    }

                    
                    Button(action: {
                        
                        self.showPassword.toggle()
                        
                    }) {
                        
                        Image(systemName: self.showPassword ? "eye.fill" : "eye.slash.fill")
                            .padding(.trailing, 10)
                    }
                }
                
                HStack {
                    
                    if self.showConfirmedPassword {
                        TextField("Confirm Password", text: self.$activistSignUpManager.confirmedPassword).textFieldStyle(RoundedBorderTextFieldStyle()).disableAutocorrection(true)
                            .padding(.horizontal, 15)
                    }
                    else {
                        SecureField("Confirm Password", text: self.$activistSignUpManager.confirmedPassword).textFieldStyle(RoundedBorderTextFieldStyle()).disableAutocorrection(true)
                            .padding(.horizontal, 15)
                    }

                    
                    Button(action: {
                        
                        self.showConfirmedPassword.toggle()
                        
                    }) {
                        
                        Image(systemName: self.showConfirmedPassword ? "eye.fill" : "eye.slash.fill")
                            .padding(.trailing, 10)
                    }
                }
                HStack {
                    Button("← Back", action: {
                        self.activistSignUpManager.pageNumber -= 1
                    }).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.05 ).background(Color.fireOrange).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
                    
                    Button("Next →", action: {
                        if validatePasswords() == nil {
                            self.activistSignUpManager.pageNumber += 1
                        }
                    }).alert(isPresented: self.$alert) {
                        Alert(title: Text("Password Error"), message: Text(self.errorMessage), dismissButton: .default(Text("OK")))
                    
                    }.foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.05 ).background(Color.earthGreen).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
                }
            Spacer()
            }.padding(.horizontal, UIScreen.main.bounds.width/20)
    }
    
    private func isPasswordValid(password: String) -> Bool {
        
        let passwordTest = NSPredicate.init(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
        
    }
    
    private func doPasswordsMatch(password: String, confirmedPassword: String) -> Bool {
        
        if password != confirmedPassword {
            return false
        }
        return true
    }
    
    private func validatePasswords() -> String? {
        let cleanedPassword = self.activistSignUpManager.password.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedConfirmedPassword = self.activistSignUpManager.confirmedPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedPassword == "" || cleanedConfirmedPassword == "" {
            self.errorMessage = "Please fill in both fields."
            self.alert.toggle()
            return "Error"
        }
        
        if isPasswordValid(password: cleanedPassword) == false {
            self.errorMessage = "Please make sure your password is at least 8 characters and contains a capital letter and a number."
            self.alert.toggle()
            return "Error"
        }
        
        if doPasswordsMatch(password: cleanedPassword, confirmedPassword: cleanedConfirmedPassword) == false {
            self.errorMessage = "Please make sure your password entries match."
            self.alert.toggle()
            return "Error"
        }
        
        return nil
        
    }
}


