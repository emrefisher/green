//
//  OrganizerSignUpReviewSubmission.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/26/21.
//

import SwiftUI

struct OrganizerSignUpReviewSubmission: View {
    @ObservedObject var organizerSignUpManager: OrganizerSignUpManager
    @EnvironmentObject var sessionManager: UserSessionManager
    
    var body: some View {
        VStack {
            if self.organizerSignUpManager.pickedCoverPhoto != nil {
                self.organizerSignUpManager.pickedCoverPhoto!
                    .resizable()
                    .clipShape(Rectangle())
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/5, alignment: .center)
            }
            if self.organizerSignUpManager.pickedProfileImage != nil {
                self.organizerSignUpManager.pickedProfileImage!
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 200, height: 200, alignment: .center)
            }
            Text(self.organizerSignUpManager.orgName)
            Text(self.organizerSignUpManager.orgDescription)
            Spacer()
            Button("Create Profile", action: {
                sessionManager.signUpAsOrganizer(email: self.organizerSignUpManager.email, password: self.organizerSignUpManager.password, confimedPassword: self.organizerSignUpManager.confirmedPassword, orgName: self.organizerSignUpManager.orgName, orgDescription: self.organizerSignUpManager.orgDescription, orgLink: self.organizerSignUpManager.orgWebsite, profilePic: self.organizerSignUpManager.profilePicData, coverPic: self.organizerSignUpManager.coverPhotoData)
            })
        }.alert(isPresented: $sessionManager.alert) {
            Alert(title: Text("Sign-Up Error"), message: Text(sessionManager.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

