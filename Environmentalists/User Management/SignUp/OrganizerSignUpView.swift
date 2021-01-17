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
        case 1:
            OrganizerSignUpPageOne(organizerSignUpManager: self.organizerSignUpManager, accountType: self.$accountType)
        case 2:
            OrganizerSignUpPageTwo(organizerSignUpManager: self.organizerSignUpManager)
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
    @Published var pageNumber = 1
    
}
