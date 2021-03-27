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
        VStack (spacing: 15) {
            ProgressView(value: CGFloat(self.organizerSignUpManager.pageNumber), total: 7) {
                HStack(alignment: .center) {
                    Text("Progress: (\(self.organizerSignUpManager.pageNumber)/7)")
                }
            }
            Spacer()
            Text("Review").font(.largeTitle).padding(0)
            ZStack {
                if self.organizerSignUpManager.pickedCoverPhoto != nil {
                    self.organizerSignUpManager.pickedCoverPhoto!
                        .resizable()
                        .clipShape(Rectangle())
                        .frame(width: (UIScreen.main.bounds.width - UIScreen.main.bounds.width/10), height: UIScreen.main.bounds.height/5, alignment: .center)
                }
                if self.organizerSignUpManager.pickedProfileImage != nil {
                    self.organizerSignUpManager.pickedProfileImage!
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 130, height: 130, alignment: .center)
                        .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(Color.earthGreen, lineWidth: 1))
                        .padding(.top, 120)
                        
                }
            }
            Text(self.organizerSignUpManager.orgName).font(.headline)
            Text(self.organizerSignUpManager.orgDescription).padding(.horizontal, 15).font(.caption).frame(width: UIScreen.main.bounds.width - 30, height: 80)
            Spacer()
            HStack {
                Button("← Back", action: {
                    self.organizerSignUpManager.pageNumber -= 1
                }).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.05 ).background(Color.fireOrange).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
                Button("Finish", action: {
                    sessionManager.signUpAsOrganizer(email: self.organizerSignUpManager.email, password: self.organizerSignUpManager.password, confimedPassword: self.organizerSignUpManager.confirmedPassword, orgName: self.organizerSignUpManager.orgName, orgDescription: self.organizerSignUpManager.orgDescription, orgLink: self.organizerSignUpManager.orgWebsite, profilePic: self.organizerSignUpManager.profilePicData, coverPic: self.organizerSignUpManager.coverPhotoData)
                }).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.05 ).background(Color.earthGreen).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
            }
        }.alert(isPresented: $sessionManager.alert) {
            Alert(title: Text("Sign-Up Error"), message: Text(sessionManager.errorMessage), dismissButton: .default(Text("OK")))
        }.padding(.horizontal, UIScreen.main.bounds.width/20).padding(.vertical, UIScreen.main.bounds.height/10)
    }
}

