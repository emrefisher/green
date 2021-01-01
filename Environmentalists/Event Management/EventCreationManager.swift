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
    @Published var coverimagedata = Data()
    
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
        //let storage = Storage.storage().reference()
        //if let uploadData = UIImagePNGRepresentation(self.image!) {
            
       // }
        
        /*storage.child("coverpics").child(res!.user.uid).putData(coverPic, metadata: nil) { (_, err) in
            
            if err != nil {
                self.errorMessage = err!.localizedDescription
                self.alert.toggle()
                return
            }
            
            storage.child("coverpics").child(res!.user.uid).downloadURL { (coverpicURL, err) in
                
                if err != nil{
                    self.errorMessage = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
               
                
                
                
                userRef.document("\(orgName)").updateData([ "Cover Pic URL": "\(coverpicURL!)"])*/
        
        
        
        
        
        
       
        
    
        userRef.document("\(self.organizer): \(self.title)").setData(["Name": self.title, "Organizer": currentUser.currentUserInformation.name, "Organizer ID": currentUser.currentUserInformation.orgID!, "Date": self.date, "Time": self.time, "Number Attending": 0, "Description": self.description, "Location": self.location])
        
       /* let riversRef = storageRef.child("\(self.coverimagedata)")

        // 3 Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(coverimagedata, metadata: nil) { (metadata, error) in
          if let error = error {
            // 4 Uh-oh, an error occurred!
            return
          }

          // 5
            riversRef.downloadURL(completion: { (url, error) in
            if let error = error { return }
            // 6
                userRef.document("\(self.organizer): \(self.title)").updateData([ "Cover Pic URL": "\(url!)"])
          })
            
        }*/
    
}
}
