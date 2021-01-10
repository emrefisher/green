//
//  EventManager.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/5/20.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct Event: Identifiable {
    
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
    
}

class EventManager: ObservableObject {
    
    @Published var eventInformation = [Event]()
    
    init() {
        if self.eventInformation.count == 0 {
            getEventInformation()
        }
        print(eventInformation.count)
    }
    
    func clearEvents() {
        self.eventInformation = [Event]()
    }
    
    func getEventInformation() {
        let database = Firestore.firestore()
        database.collection("Events").getDocuments { (querySnapshot, err) in
            if err != nil {
                print("Error getting documents: \(err!)")
            }

            for document in querySnapshot!.documents {
                let id = document.documentID
                let eventTitle = document.get("Name") as! String
                let organizer = document.get("Organizer") as! String
                let organizerID = document.get("Organizer ID") as! String
                let eventDescription = document.get("Description") as! String
                let date = document.get("Date") as! String
                let time = document.get("Time") as! String
                let location = document.get("Location") as! String
                let numAttending = document.get("Number Attending") as! Int
                let eventPhotoURL = document.get("Event Photo URL") as! String
                self.eventInformation.append(Event(id: id, eventTitle: eventTitle, eventOrganizer: organizer, eventOrganizerID: organizerID, eventDescription: eventDescription, date: date, time: time, location: location, numAttending: numAttending, eventPhotoURL: eventPhotoURL))
            }

        }
    }
}

