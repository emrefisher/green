//
//  ActivistSignUpPageThree.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/29/21.
//

import SwiftUI

struct ActivistSignUpPageThree: View {
    
    @ObservedObject var activistSignUpManager: ActivistSignUpManager
    @State private var alert = false
    
    var body: some View {
        VStack {
            
            Button("Back", action: {
                self.activistSignUpManager.pageNumber -= 1
            }).padding(.trailing, 330.0)
            .padding(.bottom, 10)
            
            VStack(spacing: UIScreen.main.bounds.width / 10) {
                
                Text("Enter Name")
                    .font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
                
                TextField("First Name", text: self.$activistSignUpManager.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Last Name", text: self.$activistSignUpManager.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
            }
            HStack {
              
                Button("Next", action: {
                    if !self.activistSignUpManager.firstName.isEmpty && !self.activistSignUpManager.lastName.isEmpty {
                        self.activistSignUpManager.pageNumber += 1
                    }
                    else {
                        self.alert.toggle()
                    }
                }).frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height / 20).background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))).clipShape(Capsule()).padding(.vertical, 7.5).padding(.bottom, 100.0)
            }
            
            Spacer()
        }
        .alert(isPresented: self.$alert) {
            Alert(title: Text(""), message: Text("Please fill in both fields"), dismissButton: .default(Text("OK")))
        }
    }
  
}

