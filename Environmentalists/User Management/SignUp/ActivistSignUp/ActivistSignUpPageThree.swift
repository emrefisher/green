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
            HStack(spacing: UIScreen.main.bounds.width / 10) {
                TextField("First Name", text: self.$activistSignUpManager.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Last Name", text: self.$activistSignUpManager.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
            }
            HStack {
                Button("Back", action: {
                    self.activistSignUpManager.pageNumber -= 1
                })
                
                Button("Next", action: {
                    if !self.activistSignUpManager.firstName.isEmpty && !self.activistSignUpManager.lastName.isEmpty {
                        self.activistSignUpManager.pageNumber += 1
                    }
                    else {
                        self.alert.toggle()
                    }
                })
            }
        }.alert(isPresented: self.$alert) {
            Alert(title: Text(""), message: Text("Please fill in both fields"), dismissButton: .default(Text("OK")))
        }
    }
}

