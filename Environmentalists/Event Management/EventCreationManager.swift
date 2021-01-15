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
    @Published var organizer = ""
    @Published var organizerID = ""
    @Published var time = ""
    @Published var date = ""
    @Published var location = ""
    @Published var eventimagedata: Data = .init(count: 0)
    @Published var errorMessage = ""
    @Published var alert = false
    let titleCharLimit: Int
    let descriptionCharLimit: Int
    
    @Published var title = "" {
        didSet {
            if title.count > titleCharLimit && oldValue.count <= titleCharLimit {
                title = oldValue
            }
        }
    }
    
    
    @Published var description = "" {
        didSet {
            if description.count > descriptionCharLimit && oldValue.count <= descriptionCharLimit {
                description = oldValue
            }
        }
    }
    
    init(titleLimit: Int, descriptionLimit: Int) {
        titleCharLimit = titleLimit
        descriptionCharLimit = descriptionLimit
    }
    
    func clearEventData() {
        self.creationPageIndex = 0
        self.title = ""
        self.organizer = ""
        self.description = ""
        self.organizerID = ""
        self.time = ""
        self.date = ""
        self.location = ""
        self.eventimagedata = Data()
    }
    
    func publishNewEvent(currentUser: CurrentUser, date: Date) {
        
        self.organizer = currentUser.currentUserInformation.name
        let database = Firestore.firestore()
        let userRef = database.collection("Events")
        let userRefO = database.collection("Organizers")
        let eventID = UUID().uuidString
        let storage = Storage.storage().reference()
        let formatter = DateFormatter()
        let formatter1 = DateFormatter()
        formatter.dateFormat = "MMM d, y"
        formatter1.pmSymbol = "PM"
        formatter1.dateFormat = "h:mm a"
        let formattedDate = formatter.string(from: date)
        let formattedTime = formatter1.string(from: date)
        print(title)
        print(formattedDate)
        print(formattedTime)
        storage.child("EventPhotos").child(eventID).putData(eventimagedata, metadata: nil) { (_, err) in
            
            if err != nil {
                self.errorMessage = err!.localizedDescription
                self.alert.toggle()
                return
            }
            
            storage.child("EventPhotos").child(eventID).downloadURL { (url, err) in
                
                if err != nil{
                    self.errorMessage = err!.localizedDescription
                    self.alert.toggle()
                    print("This is the error: \(err!)")
                    return
                }
                
                
                userRef.document(eventID).setData(["Name": self.title, "Organizer": currentUser.currentUserInformation.name, "Organizer ID": currentUser.currentUserInformation.orgID!, "Event ID": eventID, "Date": formattedDate, "Time": formattedTime, "Number Attending": 0, "Description": self.description, "Location": self.location, "Event Photo URL": "\(url!)"])
                userRefO.document(currentUser.currentUserInformation.id).updateData(["Events": FieldValue.arrayUnion([eventID])])
                
                
            }
        }
        
    }
}
