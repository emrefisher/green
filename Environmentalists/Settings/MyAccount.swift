//
//  My Account.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/27/20.
//

import SwiftUI

struct MyAccount: View {
    
    @EnvironmentObject var currentUser: CurrentUser
    
    var body: some View {
        VStack {
            Text(self.currentUser.currentUserInformation.name)
            Text(self.currentUser.currentUserInformation.email)
        }
    }
}

struct MyAccount_Previews: PreviewProvider {
    static var previews: some View {
        MyAccount()
    }
}
