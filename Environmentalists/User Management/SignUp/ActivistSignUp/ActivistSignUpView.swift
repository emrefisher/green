//
//  ActivistSignUpView.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/28/21.
//

import SwiftUI

struct ActivistSignUpView: View {
    
    @EnvironmentObject var sessionManager: UserSessionManager
    @StateObject var activistSignUpManager = ActivistSignUpManager()
    @Binding var accountType: String
    
    var body: some View {
        switch self.activistSignUpManager.pageNumber {
        case 0:
            ActivistSignUpPageOne(activistSignUpManager: self.activistSignUpManager, accountType: self.$accountType)
        case 1:
            ActivistSignUpPageTwo(activistSignUpManager: self.activistSignUpManager)
        case 2:
            ActivistSignUpPageThree(activistSignUpManager: self.activistSignUpManager)
        case 3:
            ActivistSignUpPageFour(activistSignUpManager: self.activistSignUpManager)
        case 4:
            ActivistSignUpPageFive(activistSignUpManager: self.activistSignUpManager)
        case 5:
            ActivistSignUpReviewSubmission(activistSignUpManager: self.activistSignUpManager).environmentObject(sessionManager)
        default:
            Text("")
        }
    }
}

class ActivistSignUpManager: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmedPassword = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var pageNumber = 0
    @Published var profilePic: Image?
    @Published var pickedProfileImage: Image?
    @Published var profilePicData: Data = Data()
    @Published var dateOfBirth = Date()
    @Published var gender = ""
    
}
