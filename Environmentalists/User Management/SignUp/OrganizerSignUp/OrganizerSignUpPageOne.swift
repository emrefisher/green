//
//  OrganizerSignUpPageOne.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/16/21.
//

import SwiftUI
import Foundation
import Combine

struct OrganizerSignUpPageOne: View {
    
    @ObservedObject var organizerSignUpManager: OrganizerSignUpManager
    @Binding var accountType: String
    @State private var alert = false
    
    var body: some View {
        VStack (spacing: 30) {
            
            ProgressView(value: CGFloat(self.organizerSignUpManager.pageNumber), total: 7) {
                HStack(alignment: .center) {
                    Text("Progress: (\(self.organizerSignUpManager.pageNumber)/7)")
                }

            }
            Spacer()
            Text("Enter Email").font(.largeTitle)
            Text("Make sure you remember which email you use as you will need it to log in to the app every time.").font(.caption).padding(.horizontal, 30).frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            TextField("Example: abc123@xyz.com", text: self.$organizerSignUpManager.email).textFieldStyle(RoundedBorderTextFieldStyle()).disableAutocorrection(true)
                .padding(.horizontal, 30)
            HStack {
                Button("← Back", action: {
                    self.accountType = ""
                }).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.05 ).background(Color.fireOrange).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5).alert(isPresented: $alert) {
                    Alert(title: Text("Sign-Up Error"), message: Text("Please enter a valid email."), dismissButton: .default(Text("OK")))
                }
                Button("Next →", action: {
                    if self.textFieldValidatorEmail() {
                        self.organizerSignUpManager.pageNumber += 1
                    }
                    else {
                        self.alert.toggle()
                    }
                }).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.05 ).background(Color.earthGreen).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5).alert(isPresented: $alert) {
                    Alert(title: Text("Sign-Up Error"), message: Text("Please enter a valid email."), dismissButton: .default(Text("OK")))
                }
            }
            Spacer()
        }.padding(.vertical, UIScreen.main.bounds.height/10).padding(.horizontal, UIScreen.main.bounds.width/20)
    }
    
    private func textFieldValidatorEmail() -> Bool {
        if self.organizerSignUpManager.email.count > 100 {
            return false
        }
        let email = self.organizerSignUpManager.email
        let cleanedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        print(cleanedEmail)
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: cleanedEmail)
    }
}
