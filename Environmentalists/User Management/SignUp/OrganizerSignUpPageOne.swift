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
    @State var alert = ""
    
    var body: some View {
        VStack {
            Button("Back", action: {
                self.accountType = ""
            })
            Text("Enter Email")
            TextField("Example: abc123@xyz.com", text: self.$organizerSignUpManager.email).textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Next Page", action: {
                self.organizerSignUpManager.pageNumber += 1
            })
        }.padding(.horizontal, UIScreen.main.bounds.width/20)
    }
    
//    private func validateEmail() {
//
//
//
//    }
}
