//
//  OrganizerManager.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/11/20.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct Organizer: Identifiable {
    var id: String
    var organizerID: Int
    var organizerName: String
    var orgDescription: String
    var orgFollowers: Int
    var orgLocation: String
    var email: String
    var orgWebsite: String
    var orgProfilePic: String
    var orgCoverPic: String
}

class OrganizerInfo: ObservableObject {
    
    @Published var organizerInformation = Organizer(id: "", organizerID: 0, organizerName: "", orgDescription: "", orgFollowers: 0, orgLocation: "", email: "", orgWebsite: "", orgProfilePic: "", orgCoverPic: "")
    
    func getOrganizerInformation(organizationID: Int) {
        let database = Firestore.firestore()
        database.collection("Organizers").whereField("Organizer ID", isEqualTo: organizationID).getDocuments() { (querySnapshot, err) in
            
            if err != nil {
                print("Error getting documents: \(err!)")
            }
            
            for document in querySnapshot!.documents {
                
                self.organizerInformation.id = document.documentID
                self.organizerInformation.organizerName = document.get("Organization Name") as! String
                self.organizerInformation.orgDescription = document.get("Organization Description") as! String
                self.organizerInformation.orgFollowers = document.get("Number of Followers") as! Int
                self.organizerInformation.organizerID = organizationID
                self.organizerInformation.orgLocation = document.get("Organization Location") as! String
                self.organizerInformation.email = document.get("Email") as! String
                self.organizerInformation.orgWebsite = document.get("Organization Website Link") as! String
                self.organizerInformation.orgProfilePic = document.get("Profile Pic URL") as! String
                self.organizerInformation.orgCoverPic = document.get("Cover Pic URL") as! String
                
            }
        }
    }

}
