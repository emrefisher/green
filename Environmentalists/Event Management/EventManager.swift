//
//  EventManager.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/5/20.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Event: Identifiable, Codable {
    
    var id: String
    var eventTitle: String
    var eventOrganizer: String
    var eventOrganizerID: String
    var eventDescription: String
    var date: String
    var time: String
    var location: String
    var numAttending: Int
    var eventPhotoURL: String
    //var systemStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "Event ID"
        case eventTitle = "Name"
        case eventOrganizer = "Organizer"
        case eventOrganizerID = "Organizer ID"
        case eventDescription = "Description"
        case date = "Date"
        case time = "Time"
        case location = "Location"
        case numAttending = "Number Attending"
        case eventPhotoURL = "Event Photo URL"
        //case systemStatus = "true"
    }
    
}

class EventManager: ObservableObject {
    
    @Published var eventInformation = [Event]()
    private var db = Firestore.firestore()
    
    init() {
        getEventInformation()
    }
    
    func clearEvents() {
        self.eventInformation = [Event]()
    }
    
    func getEventInformation() {
        db.collection("Events").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            
            self.eventInformation = documents.compactMap { (queryDocumentSnapshot) -> Event? in
                return try? queryDocumentSnapshot.data(as: Event.self)
            }
            print(self.eventInformation)
        }
    }
    
//    func getEventInformation() {
//        let database = Firestore.firestore()
//        database.collection("Events").getDocuments() { (snap, err) in
//            if err != nil {
//                print("Error getting documents: \(err!)")
//            }
//
//            for document in snap!.documents {
//                let id = document.documentID
//                let eventTitle = document.get("Name") as! String
//                let organizer = document.get("Organizer") as! String
//                let organizerID = document.get("Organizer ID") as! String
//                let eventDescription = document.get("Description") as! String
//                let date = document.get("Date") as! String
//                let time = document.get("Time") as! String
//                let location = document.get("Location") as! String
//                let numAttending = document.get("Number Attending") as! Int
//                let eventPhotoURL = document.get("Event Photo URL") as! String
//                self.eventInformation.append(Event(id: id, eventTitle: eventTitle, eventOrganizer: organizer, eventOrganizerID: organizerID, eventDescription: eventDescription, date: date, time: time, location: location, numAttending: numAttending, eventPhotoURL: eventPhotoURL))
//            }
//
//        }
//    }
}

