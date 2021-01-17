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
    
    var body: some View {
            VStack(alignment: .leading){
                
                Text("Password")
                    .font(.headline)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .padding([.leading, .trailing], 20)
                
                HStack {
                    
                    if self.showPassword {
                        TextField("Enter Password", text: self.$organizerSignUpManager.password)
                        .padding([.leading, .trailing], 20)
                    }
                    else {
                        SecureField("Enter Password", text: self.$organizerSignUpManager.password)
                        .padding([.leading, .trailing], 20)
                    }

                    
                    Button(action: {
                        
                        self.showPassword.toggle()
                        
                    }) {
                        
                        Image(systemName: self.showPassword ? "eye.fill" : "eye.slash.fill")
                            .padding(.trailing, 17.5)
                    }
                }
                
                Text("Password must be at least 8 total characters long and must include at least one capital letter and one number.")
                
                HStack {
                    
                    if self.showConfirmedPassword {
                        TextField("Enter Password", text: self.$organizerSignUpManager.confirmedPassword)
                        .padding([.leading, .trailing], 20)
                    }
                    else {
                        SecureField("Enter Password", text: self.$organizerSignUpManager.confirmedPassword)
                        .padding([.leading, .trailing], 20)
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
