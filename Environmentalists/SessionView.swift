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
    @State var showAuthorizationAlert = false
    
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
            CreateEventView()
                .environmentObject(currentUser)
                .tabItem {
                    Image(systemName: "plus")
                    Text("Create Event")
                }
                .tag(1)
            Settings()
                .environmentObject(sessionManager)
                .environmentObject(currentUser)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(2)
        }.onAppear() {
            if self.currentUser.currentUserInformation.name == "" {
                self.currentUser.getUserInformation()
            }
        }
        .alert(isPresented: self.$showAuthorizationAlert) {
            Alert(title: Text("Authorization Alert"), message: Text("You are not authorized to create events. Please exit this page"), dismissButton: .default(Text("I understand")))
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
