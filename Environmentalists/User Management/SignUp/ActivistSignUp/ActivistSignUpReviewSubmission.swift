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
        VStack (spacing: 30) {
            
            ProgressView(value: CGFloat(self.activistSignUpManager.pageNumber), total: 6) {
                HStack(alignment: .center) {
                    Text("Progress: (\(self.activistSignUpManager.pageNumber)/6)")
                }
            }.padding(.top, 85)
            .padding(.horizontal, 20)
            Spacer()
            Text("Review Your Info").font(.largeTitle)
            if self.activistSignUpManager.pickedProfileImage != nil {
                self.activistSignUpManager.pickedProfileImage!
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 200, height: 200, alignment: .center)
            }

            Text("Name: \(self.activistSignUpManager.firstName) \(self.activistSignUpManager.lastName)")
            Text("Email: \(self.activistSignUpManager.email)")
            HStack {
                Button("← Back", action: {
                    self.activistSignUpManager.pageNumber -= 1
                }).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.05 ).background(Color.fireOrange).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
                Button("Create Profile", action: {
                    sessionManager.signUpAsActivist(email: self.activistSignUpManager.email, password: self.activistSignUpManager.password, confirmedPassword: self.activistSignUpManager.confirmedPassword, firstName: self.activistSignUpManager.firstName, lastName: self.activistSignUpManager.lastName, dateOfBirth: self.activistSignUpManager.dateOfBirth, profilePic: self.activistSignUpManager.profilePicData)
                }).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.05 ).background(Color.earthGreen).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
            }
            Spacer()
        }.alert(isPresented: $sessionManager.alert) {
            Alert(title: Text("Sign-Up Error"), message: Text(sessionManager.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}


