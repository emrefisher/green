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
        getEventInformation()
    }
    
    func clearEvents() {
        self.eventInformation = [Event]()
    }
    
    func getEventInformation() {
        let database = Firestore.firestore()
        database.collection("Events").addSnapshotListener { (snap, err) in
            if err != nil {
                print("Error getting documents: \(err!)")
            }
            
            guard let docs = snap else {return}
            docs.documentChanges.forEach { (doc) in
                if doc.type == .added {
                    let id = doc.document.documentID
                    let eventTitle = doc.document.data()["Name"] as! String
                    let organizer = doc.document.data()["Organizer"] as! String
                    let organizerID = doc.document.data()["Organizer ID"] as! String
                    let eventDescription = doc.document.data()["Description"] as! String
                    let date = doc.document.data()["Date"] as! String
                    let time = doc.document.data()["Time"] as! String
                    let location = doc.document.data()["Location"] as! String
                    let numAttending = doc.document.data()["Number Attending"] as! Int
                    let eventPhotoURL = doc.document.data()["Event Photo URL"] as! String
                    self.eventInformation.append(Event(id: id, eventTitle: eventTitle, eventOrganizer: organizer, eventOrganizerID: organizerID, eventDescription: eventDescription, date: date, time: time, location: location, numAttending: numAttending, eventPhotoURL: eventPhotoURL))
                }
            }


        }
    }
}

