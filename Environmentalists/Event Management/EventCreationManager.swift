//
//  EventCreationManager.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/11/20.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseStorage

class EventCreationManager: ObservableObject {
    
    @Published var creationPageIndex = 0
    @Published var title = ""
    @Published var organizer = ""
    @Published var description = ""
    @Published var organizerID = 0
    @Published var time = ""
    @Published var date = ""
    @Published var location = ""
    
    func clearEventData() {
        self.creationPageIndex = 0
        self.title = ""
        self.organizer = ""
        self.description = ""
        self.organizerID = 0
        self.time = ""
        self.date = ""
        self.location = ""
    }
    
    func publishNewEvent(currentUser: CurrentUser) {
        
        let database = Firestore.firestore()
        let userRef = database.collection("Events")
        
        userRef.document("\(self.organizer): \(self.title)").setData(["Name": self.title, "Organizer": currentUser.currentUserInformation.name, "Organizer ID": currentUser.currentUserInformation.orgID!, "Date": self.date, "Time": self.time, "Number Attending": 0, "Description": self.description, "Location": self.location])
        
    }
    
}
