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
    @Published var coverimagedata: Data = .init(count: 0)
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
        self.location = ""
        self.coverimagedata = Data()
    }
    
    func publishNewEvent(currentUser: CurrentUser) {
        
        let database = Firestore.firestore()
        
        let userRef = database.collection("Events")
        let storage = Storage.storage().reference()
        
        var eventCount = 0
        userRef.getDocuments() { (querySnapshot, err) in
            
            if err != nil {
                print("Error getting documents: \(err!)")
            }
            
            for _ in querySnapshot!.documents {
                
                eventCount += 1
            
            }
        }
        
        storage.child("EventPhotos").child("\(currentUser.currentUserInformation.name): \(16)").putData(coverimagedata, metadata: nil) { (_, err) in
            
            if err != nil {
                self.errorMessage = err!.localizedDescription
                self.alert.toggle()
                return
            }
            
            storage.child("EventPhotos").child("\(currentUser.currentUserInformation.name): \(16)").downloadURL { (url, err) in
                
                if err != nil{
                    self.errorMessage = err!.localizedDescription
                    self.alert.toggle()
                    print("This is the error: \(err!)")
                    return
                }
                
                
                userRef.document("\(self.organizer): \(self.title)").setData(["Name": self.title, "Organizer": currentUser.currentUserInformation.name, "Organizer ID": currentUser.currentUserInformation.orgID!, "Date": self.date, "Time": self.time, "Number Attending": 0, "Description": self.description, "Location": self.location, "Event Photo URL": "\(url!)"])
                
            }
        }
        
    }
}
