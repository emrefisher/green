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
            VStack(alignment: .leading){
                
                Button("Back", action: {
                    self.activistSignUpManager.pageNumber -= 1
                })
                
                Text("Password Information")
                    .font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
                    .padding(.leading,100)
                    .padding(.bottom, 10)
                
                Text("Choose Password")
                    .font(.headline)
                    .fontWeight(.light)
                    .foregroundColor(.black)
                    .padding([.leading, .trailing], 20)
                
                HStack {
                    
                    if self.showPassword {
                        TextField("Enter Password", text: self.$activistSignUpManager.password).textFieldStyle(RoundedBorderTextFieldStyle()).disableAutocorrection(true)
                    }
                    else {
                        SecureField("Enter Password", text: self.$activistSignUpManager.password).textFieldStyle(RoundedBorderTextFieldStyle()).disableAutocorrection(true)
                    }

                    
                    Button(action: {
                        
                        self.showPassword.toggle()
                        
                    }) {
                        
                        Image(systemName: self.showPassword ? "eye.fill" : "eye.slash.fill")
                            .padding(.trailing, 17.5)
                    }
                }
                
                Text("Password must be at least 8 total characters long and must include at least one capital letter and one number.").font(.caption).foregroundColor(.black).padding(.bottom)
                
                
                Text("Confirm Password")
                    .font(.headline)
                    .fontWeight(.light)
                    .foregroundColor(.black)
                    .padding([.leading, .trailing], 20)
                
                HStack {
                    
                    if self.showConfirmedPassword {
                        TextField("Confirm Password", text: self.$activistSignUpManager.confirmedPassword).textFieldStyle(RoundedBorderTextFieldStyle()).disableAutocorrection(true)
                    }
                    else {
                        SecureField("Confirm Password", text: self.$activistSignUpManager.confirmedPassword).textFieldStyle(RoundedBorderTextFieldStyle()).disableAutocorrection(true)
                    }

                    
                    Button(action: {
                        
                        self.showConfirmedPassword.toggle()
                        
                    }) {
                        
                        Image(systemName: self.showConfirmedPassword ? "eye.fill" : "eye.slash.fill")
                            .padding([.bottom, .trailing], 17.5)
                    }
                }
            
                HStack {
                    
                    
                    Button("Next", action: {
                        if validatePasswords() == nil {
                            self.activistSignUpManager.pageNumber += 1
                        }
                    }).frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height / 20).background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))).clipShape(Capsule()).padding(.vertical, 7.5)
                    .alert(isPresented: self.$alert) {
                        Alert(title: Text("Password Error"), message: Text(self.errorMessage), dismissButton: .default(Text("OK")))
                    }
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


