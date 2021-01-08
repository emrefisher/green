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
import FirebaseAuth

class EventCreationManager: ObservableObject {
    
    @Published var creationPageIndex = 0
    @Published var title = ""
    @Published var organizer = ""
    @Published var description = ""
    @Published var organizerID = 0
    @Published var time = ""
    @Published var date = ""
    @Published var location = ""
    @Published var eventimagedata: Data = .init(count: 0)
    @Published var errorMessage = ""
    @Published var alert = false
    
    func clearEventData() {
        self.creationPageIndex = 0
        self.title = ""
        self.organizer = ""
        self.description = ""
        self.organizerID = 0
        self.time = ""
        self.date = ""
        self.location = "Langhorne, PA"
        self.eventimagedata = Data()
    }
    
    func publishNewEvent(currentUser: CurrentUser) {
        
        
        let database = Firestore.firestore()
        let userRef = database.collection("Events")
        let eventID = UUID().uuidString
        let storage = Storage.storage().reference()
        
        storage.child("EventPhotos").child("161").putData(eventimagedata, metadata: nil) { (_, err) in
            
            if err != nil {
                self.errorMessage = err!.localizedDescription
                self.alert.toggle()
                return
            }
            
            storage.child("EventPhotos").child("161").downloadURL { (url, err) in
                
                if err != nil{
                    self.errorMessage = err!.localizedDescription
                    self.alert.toggle()
                    print("This is the error: \(err!)")
                    return
                }
                
                
                userRef.document("\(self.organizer): \(self.title)").setData(["Name": self.title, "Organizer": currentUser.currentUserInformation.name, "Organizer ID": currentUser.currentUserInformation.orgID!, "Event ID": eventID, "Date": self.date, "Time": self.time, "Number Attending": 0, "Description": self.description, "Location": self.location, "Event Photo URL": "\(url!)"])
                
                
                
            }
        }
        
    }
}
