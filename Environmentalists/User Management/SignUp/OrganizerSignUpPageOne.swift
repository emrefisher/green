//
//  OrganizerSignUpPageOne.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/16/21.
//

import SwiftUI

struct OrganizerSignUpPageOne: View {
    
    @ObservedObject var organizerSignUpManager: OrganizerSignUpManager
    @Binding var accountType: String
    @State private var alert = false
    
    var body: some View {
        VStack {
            Button("Back", action: {
                self.accountType = ""
            })
            Text("Enter Email")
            TextField("Example: abc123@xyz.com", text: self.$organizerSignUpManager.email).textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Next Page", action: {
                if self.textFieldValidatorEmail() {
                    self.organizerSignUpManager.pageNumber += 1
                }
                else {
                    self.alert.toggle()
                }
            }).alert(isPresented: $alert) {
                Alert(title: Text("Sign-Up Error"), message: Text("Please enter a valid email."), dismissButton: .default(Text("OK")))
            }
        }.padding(.horizontal, UIScreen.main.bounds.width/20)
    }
    
    private func textFieldValidatorEmail() -> Bool {
        if self.organizerSignUpManager.email.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self.organizerSignUpManager.email)
    }
}
