//
//  ActivistSignUpPageOne.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/28/21.
//

import SwiftUI

struct ActivistSignUpPageOne: View {
    
    @ObservedObject var activistSignUpManager: ActivistSignUpManager
    @Binding var accountType: String
    @State private var alert = false
    
    var body: some View {
        VStack {
    
            Button("Back", action: {
                self.accountType = ""
            }).padding(.trailing, 330.0)
            .padding(.bottom, 10.0)
            Text("Enter Email")
                .font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
            TextField("Example: abc123@xyz.com", text: self.$activistSignUpManager.email).textFieldStyle(RoundedBorderTextFieldStyle()).disableAutocorrection(true)
                .padding(.bottom, 10.0)
            Button("Next", action: {
                if self.textFieldValidatorEmail() {
                    self.activistSignUpManager.pageNumber += 1
                    
                    
                
                }
                else {
                    self.alert.toggle()
                }
            }).frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height / 20).background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))).clipShape(Capsule()).padding(.bottom, 7.5)
            .alert(isPresented: $alert) {
                Alert(title: Text("Sign-Up Error"), message: Text("Please enter a valid email."), dismissButton: .default(Text("OK")))
                    
            }
            Spacer()
        }.padding(.horizontal, UIScreen.main.bounds.width/20)
        
        

    }
    
    private func textFieldValidatorEmail() -> Bool {
        if self.activistSignUpManager.email.count > 100 {
            return false
        }
        let email = self.activistSignUpManager.email
        let cleanedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        print(cleanedEmail)
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: cleanedEmail)
    }
}


