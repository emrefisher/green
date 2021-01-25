//
//  OrganizerSignUpPageTwo.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/16/21.
//

import SwiftUI

struct OrganizerSignUpPageTwo: View {
    
    @ObservedObject var organizerSignUpManager: OrganizerSignUpManager
    @State private var showPassword = false
    @State private var showConfirmedPassword = false
    @State private var errorMessage = ""
    @State private var alert = false
    
    var body: some View {
            VStack(alignment: .leading){
                
                Text("Choose Password")
                    .font(.headline)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .padding([.leading, .trailing], 20)
                
                HStack {
                    
                    if self.showPassword {
                        TextField("Enter Password", text: self.$organizerSignUpManager.password).textFieldStyle(RoundedBorderTextFieldStyle()).disableAutocorrection(true)
                    }
                    else {
                        SecureField("Enter Password", text: self.$organizerSignUpManager.password).textFieldStyle(RoundedBorderTextFieldStyle()).disableAutocorrection(true)
                    }

                    
                    Button(action: {
                        
                        self.showPassword.toggle()
                        
                    }) {
                        
                        Image(systemName: self.showPassword ? "eye.fill" : "eye.slash.fill")
                            .padding(.trailing, 17.5)
                    }
                }
                
                Text("Password must be at least 8 total characters long and must include at least one capital letter and one number.").font(.caption).foregroundColor(.white)
                
                
                Text("Confirm Password")
                HStack {
                    
                    if self.showConfirmedPassword {
                        TextField("Confirm Password", text: self.$organizerSignUpManager.confirmedPassword).textFieldStyle(RoundedBorderTextFieldStyle()).disableAutocorrection(true)
                    }
                    else {
                        SecureField("Confirm Password", text: self.$organizerSignUpManager.confirmedPassword).textFieldStyle(RoundedBorderTextFieldStyle()).disableAutocorrection(true)
                    }

                    
                    Button(action: {
                        
                        self.showConfirmedPassword.toggle()
                        
                    }) {
                        
                        Image(systemName: self.showConfirmedPassword ? "eye.fill" : "eye.slash.fill")
                            .padding(.trailing, 17.5)
                    }
                }
                HStack {
                    Button("Back", action: {
                        self.organizerSignUpManager.pageNumber -= 1
                    })
                    
                    Button("Next", action: {
                        if validatePasswords() == nil {
                            self.organizerSignUpManager.pageNumber += 1
                        }
                    }).alert(isPresented: self.$alert) {
                        Alert(title: Text("Password Error"), message: Text(self.errorMessage), dismissButton: .default(Text("OK")))
                    }
                }
                
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
        let cleanedPassword = self.organizerSignUpManager.password.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedConfirmedPassword = self.organizerSignUpManager.confirmedPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        
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
