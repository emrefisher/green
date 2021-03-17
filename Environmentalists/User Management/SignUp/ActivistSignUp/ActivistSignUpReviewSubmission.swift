//
//  ActivistSignUpReviewSubmission.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/29/21.
//

import SwiftUI

struct ActivistSignUpReviewSubmission: View {
    
    @ObservedObject var activistSignUpManager: ActivistSignUpManager
    @EnvironmentObject var sessionManager: UserSessionManager
    
    var body: some View {
        VStack {
            HStack {
                Button("Back", action: {
                    self.activistSignUpManager.pageNumber -= 1
                })
                Spacer()
            }.padding()
            Spacer()
            if self.activistSignUpManager.pickedProfileImage != nil {
                self.activistSignUpManager.pickedProfileImage!
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 200, height: 200, alignment: .center)
            }

            Text("Name: \(self.activistSignUpManager.firstName) \(self.activistSignUpManager.lastName)")
            
            Spacer()
            Button("Create Profile", action: {
                sessionManager.signUpAsActivist(email: self.activistSignUpManager.email, password: self.activistSignUpManager.password, confirmedPassword: self.activistSignUpManager.confirmedPassword, firstName: self.activistSignUpManager.firstName, lastName: self.activistSignUpManager.lastName, dateOfBirth: self.activistSignUpManager.dateOfBirth, profilePic: self.activistSignUpManager.profilePicData)
            })
            Spacer()
        }.alert(isPresented: $sessionManager.alert) {
            Alert(title: Text("Sign-Up Error"), message: Text(sessionManager.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}


