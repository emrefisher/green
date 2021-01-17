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
                
            }.padding(.horizontal, UIScreen.main.bounds.width/20)
    }
}
