//
//  OrganizerSignUpView.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/16/21.
//

import SwiftUI

struct OrganizerSignUpView: View {
    
    @EnvironmentObject var sessionManager: UserSessionManager
    @StateObject var organizerSignUpManager = OrganizerSignUpManager()
    @Binding var accountType: String
    
    var body: some View {
        switch self.organizerSignUpManager.pageNumber {
        case 0:
            OrganizerSignUpPageOne(organizerSignUpManager: self.organizerSignUpManager, accountType: self.$accountType)
        case 1:
            OrganizerSignUpPageTwo(organizerSignUpManager: self.organizerSignUpManager)
        case 2:
            OrganizerSignUpPageThree(organizerSignUpManager: self.organizerSignUpManager)
        case 3:
            OrganizerSignUpPageFour(organizerSignUpManager: self.organizerSignUpManager)
        case 4:
            OrganizerSignUpPageFive(organizerSignUpManager: self.organizerSignUpManager)
        case 5:
            OrganizerSignUpPageSix(organizerSignUpManager: self.organizerSignUpManager)
        case 6:
            OrganizerSignUpReviewSubmission(organizerSignUpManager: self.organizerSignUpManager).environmentObject(sessionManager)
        default:
            Text("")
        }
    }
}

struct OrganizerSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizerSignUpView(accountType: .constant(""))
    }
}

class OrganizerSignUpManager: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmedPassword = ""
    @Published var orgName = ""
    @Published var orgDescription = ""
    @Published var orgLocation = ""
    @Published var orgWebsite = ""
    @Published var pageNumber = 0
    @Published var profilePic: Image?
    @Published var pickedProfileImage: Image?
    @Published var profilePicData: Data = Data()
    @Published var coverPhoto: Image?
    @Published var pickedCoverPhoto: Image?
    @Published var coverPhotoData: Data = Data()
    @Published var orgFacebook = ""
    @Published var orgInsta = ""
    @Published var orgYoutube = ""
    @Published var orgTwitter = ""
    
}
