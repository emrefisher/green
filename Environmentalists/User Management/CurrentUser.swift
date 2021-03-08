//
//  CurrentUser.swift
//  Environmentalists
//
//  Created by Ian Campbell on 10/15/20.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Identifiable {
    
    var id: String
    var name: String
    var email: String
    var accountType: String
    var profPicURL: String
    var coverPhotoURL: String
    var numberFollowers: Int?
    var description: String?
    var location: String?
    var websiteLink: String?
    var orgID: String?
    var userEventIDs: [String]
    var userEvents: [Event]
    
}

class CurrentUser: ObservableObject {
    
    let user = Auth.auth().currentUser
    @Published var currentUserInformation = User(id: "", name: "", email: "'", accountType: "", profPicURL: "", coverPhotoURL: "", numberFollowers: nil, description: nil, location: nil, websiteLink: nil, orgID: nil, userEventIDs: [String](), userEvents: [Event]())
//    @Published var eventListChanged = false
    @Published var pastEvents = [Event]()
    @Published var upcomingEvents = [Event]()
    
    
    init() {
        getUserInformation()
    }
    
    func getUserInformation() {
        
        let UID = user!.uid
        let database = Firestore.firestore()
        
        if self.currentUserInformation.id == "" {
        database.collection("Organizers").whereField("Organizer ID", isEqualTo: UID).getDocuments() { (querySnapshot, err) in
            
            if err != nil {
                print("Error getting documents: \(err!)")
            }
            
            for document in querySnapshot!.documents {
                
                self.currentUserInformation.id = document.documentID
                self.currentUserInformation.name = document.get("Organization Name") as! String
                self.currentUserInformation.email = document.get("Email") as! String
                self.currentUserInformation.accountType = document.get("Account Type") as! String
                self.currentUserInformation.profPicURL = document.get("Profile Pic URL") as! String
                self.currentUserInformation.coverPhotoURL = document.get("Cover Pic URL") as! String
//                self.currentUserInformation.numberFollowers = (document.get("Number of Followers") as! Int)
                self.currentUserInformation.description = (document.get("Organization Description") as! String)
                self.currentUserInformation.websiteLink = (document.get("Organization Website Link") as! String)
                self.currentUserInformation.location = (document.get("Organization Location") as! String)
                self.currentUserInformation.orgID = (document.get("Organizer ID") as! String)
                self.currentUserInformation.userEventIDs = (document.get("Events") as! [String])
                self.currentUserInformation.accountType = "Organizer"
            }
            
        }
        }
        
        if self.currentUserInformation.id == "" {
            
            database.collection("Activists").whereField("UID", isEqualTo: UID).getDocuments() { (querySnapshot, err) in
                
                if err != nil {
                    print("Error getting documents: \(err!)")
                }
                
                for document in querySnapshot!.documents {
                    
                    self.currentUserInformation.id = document.documentID
                    let firstName = document.get("First Name") as! String
                    let lastName = document.get("Last Name") as! String
                    self.currentUserInformation.name = "\(firstName) \(lastName)"
                    self.currentUserInformation.email = document.get("Email") as! String
                    self.currentUserInformation.accountType = "Activist"
                    self.currentUserInformation.profPicURL = document.get("Profile Pic") as! String
                    self.currentUserInformation.userEventIDs = (document.get("Events") as! [String])
                    
                }
                
            }
            
        }
    }
    
    func getUserEvents(completion: @escaping(([Event]) -> ())) {
            
            let database = Firestore.firestore()
            let eventRef = database.collection("Events")
            let g = DispatchGroup()
            for eventID in self.currentUserInformation.userEventIDs {
                for event in self.currentUserInformation.userEvents {
                    if event.id == eventID {
                        break
                    }
                }
                g.enter()
                eventRef.document(eventID).getDocument() { (document, error) in
                    let result = Result {
                        try document?.data(as: Event.self)
                    }
                    switch result {
                    case .success(let nextEvent):
                        if let nextEvent = nextEvent {
                            self.currentUserInformation.userEvents.append(nextEvent)
                            g.leave()
                        }
                        else {
                            print("Document does not exist.")
                            g.leave()
                        }
                    case .failure(let error):
                        print("Error decoding event: \(error)")
                        g.leave()
                    }
//                    if let document = document {
//                        let id = document.documentID
//                        let eventTitle = document.get("Name") as! String
//                        let organizer = document.get("Organizer") as! String
//                        let organizerID = document.get("Organizer ID") as! String
//                        let eventDescription = document.get("Description") as! String
//                        let date = document.get("Date") as! String
//                        let time = document.get("Time") as! String
//                        let location = document.get("Location") as! String
//                        let numAttending = document.get("Number Attending") as! Int
//                        let eventPhotoURL = document.get("Event Photo URL") as! String
//                        self.currentUserInformation.userEvents.append(Event(id: id, eventTitle: eventTitle, eventOrganizer: organizer, eventOrganizerID: organizerID, eventDescription: eventDescription, date: date, time: time, location: location, numAttending: numAttending, eventPhotoURL: eventPhotoURL))
//                    } else {
//                      print("Document does not exist")
//                    }
                  }
            }
        
        g.notify(queue: .main) {
            completion(self.currentUserInformation.userEvents)
        }
            
        }
    
    
    func getSortedEvents() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM dd, yyyy"
        var pastEvents = [Event]()
        var futureEvents = [Event]()
        let now = Date()
        for event in self.currentUserInformation.userEvents {
            let date = formatter.date(from: event.date)
            if date! < now {
                pastEvents.append(event)
            }
            else {
                futureEvents.append(event)
            }
        }
        let sortedPastEvents = pastEvents.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        let sortedUpcomingEvents = futureEvents.sorted(by: {
            $0.date.compare($1.date) == .orderedAscending
        })
        
        self.pastEvents = sortedPastEvents
        self.upcomingEvents = sortedUpcomingEvents
    }
    
}


