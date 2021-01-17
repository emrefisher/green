//
//  OrganizerSignUpPageTwo.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/16/21.
//

import SwiftUI

struct OrganizerSignUpPageTwo: View {
    
    @ObservedObject var organizerSignUpManager: OrganizerSignUpManager
    @State var showPassword = false
    
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
            }.padding(.horizontal, UIScreen.main.bounds.width/20)
    }
}
