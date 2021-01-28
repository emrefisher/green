//
//  SessionView.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/3/20.
//

import SwiftUI

struct SessionView: View {
    
    @EnvironmentObject var sessionManager: UserSessionManager
    @State private var index = 0
    @ObservedObject var currentUser = CurrentUser()
    
    var body: some View {
        
        TabView(selection: self.$index) {
            SearchDirectoryView()
                .environmentObject(sessionManager)
                .environmentObject(currentUser)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Event Directory")
                }
                .tag(0)
            MyAccount()
                .environmentObject(sessionManager)
                .environmentObject(currentUser)
                .tabItem {
                    Image(systemName: "person")
                    Text("My Account")
                }
                .tag(1)
        }.onAppear() {
            if self.currentUser.currentUserInformation.name == "" {
                self.currentUser.getUserInformation()
            }
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
