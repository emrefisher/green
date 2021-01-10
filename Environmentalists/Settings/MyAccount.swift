//
//  My Account.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/27/20.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

extension Optional where Wrapped == String {
    var _bound: String? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var bound: String {
        get {
            return _bound ?? ""
        }
        set {
            _bound = newValue.isEmpty ? nil : newValue
        }
    }
}

struct MyAccount: View {
    
    @EnvironmentObject var currentUser: CurrentUser
    
    var body: some View {

        if currentUser.currentUserInformation.accountType == "Organizer" {
            MyAccountOrganizerView().environmentObject(currentUser)
        }
        else if currentUser.currentUserInformation.accountType == "Activist" {
            MyAccountActivistView().environmentObject(currentUser)
        }
    }
}


struct MyAccountOrganizerView: View {
    
    @EnvironmentObject var currentOrganizer: CurrentUser
    @State private var isEditingProfile = false
    @State private var editedFields = [String]()
    @State private var orgEvents = [Event]()
    
    var body: some View {
        
        if isEditingProfile == false {
            VStack(spacing: 0){
                VStack {
                    
                    WebImage(url: URL(string: "\(self.currentOrganizer.currentUserInformation.coverPhotoURL)"))
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/5)
                        .aspectRatio(contentMode: .fit)
                    
                }
                
                VStack(spacing: 5) {
                    
                    WebImage(url: URL(string: "\(self.currentOrganizer.currentUserInformation.profPicURL)"))
                        .resizable()
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 5))
                        .frame(width: UIScreen.main.bounds.height/8, height: UIScreen.main.bounds.height/8)
                    
                    Text(self.currentOrganizer.currentUserInformation.name)
                        .font(.headline)
                    
                    HStack(spacing: 25) {
                        Text(self.currentOrganizer.currentUserInformation.description!)
                            .font(.system(size: 10))
                            .fontWeight(.light)
                            .foregroundColor(Color.black)
                    }
                    
                    VStack() {
                        let completeURL = "https://" + self.currentOrganizer.currentUserInformation.websiteLink!
                        let url = URL(string:  completeURL)
                        if url == nil {
                            Text("Link not yet loaded")
                        }
                        else  {
                            Link(destination: url!) {
                                Image(systemName: "dollarsign.circle").resizable().frame(width: 35, height: 35).foregroundColor(.black)
                                    .background(LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0, green: 0.9791811109, blue: 0.6578459144, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.6921610236, blue: 0, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(200)
                            }
                        }
                        
                        HStack(spacing: 325) {
                            VStack(spacing: 100) {
                                HStack(spacing: 5) {
                                    Image(systemName:"mappin.and.ellipse")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                    Text(self.currentOrganizer.currentUserInformation.location!).font(.system(size: 10))
                                }
                            }
                            
                        }
                        
                        Text("\(self.currentOrganizer.currentUserInformation.numberFollowers ?? 0) Followers") .font(.system(size: 12)).bold()
                        
                    }
                }.offset(y: -UIScreen.main.bounds.height/16)
                
                Spacer()
                
                Button(action: {
                    self.isEditingProfile.toggle()
                    print(currentOrganizer.currentUserInformation)
                }) {
                    Text("Edit Profile")

                }
                
                List {
                    ForEach(self.orgEvents) { Event in
                        NavigationLink(destination: EventPage(event: Event)) {
                            EventRow(event: Event)
                        }
                    }.onDelete(perform: delete(at:))
                }
                
            }.navigationBarTitle("", displayMode: .inline)
            .onAppear() {
                if orgEvents.count == 0 {
                    getOrganizerEvents()
                }
            }

        }
        
        else {
            
            Form {
                
                Section(header: Text("Organization Name")) {
                    TextField("", text: self.$currentOrganizer.currentUserInformation.name, onEditingChanged: { _ in
                        self.editedFields.append("Organization Name")
                    }
                    )}
                Section(header: Text("Profile Description")) {
                    TextField("", text: self.$currentOrganizer.currentUserInformation.description.bound, onEditingChanged: {_ in
                        self.editedFields.append("Organization Description")
                    }
                    )}
                Section(header: Text("Organization Location")) {
                    TextField("", text: self.$currentOrganizer.currentUserInformation.location.bound, onEditingChanged: { _ in
                        self.editedFields.append("Organization Location")
                    }
                    )}
                //might need to look into https://
                Section(header: Text("Organization Website")) {
                    TextField("", text: (self.$currentOrganizer.currentUserInformation.websiteLink.bound), onEditingChanged: { _ in
                        self.editedFields.append("Organization Website Link")
                    }
                    )}
                
            }
            HStack {
                
                
                HStack {
                    Button(action: {
                        self.isEditingProfile.toggle()
                    }) {
                        Text("Cancel")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(40)
                    .offset(x: 15, y: -5)
                }
                Spacer()
                HStack {
                    Button(action: {
                        print(self.editedFields)
                        updateOrganizerInFirebase()
                        self.isEditingProfile.toggle()
                    }) {
                        Text("Save Changes")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(40)
                    .offset(x: -15, y: -5)
                }
            }
        }
    }
    
    private func updateOrganizerInFirebase() {
        
        let database = Firestore.firestore()
        let userInfo = currentOrganizer.currentUserInformation
        let eventRef = database.collection("Events")
        let userRef = database.collection("Organizers").document(userInfo.id)
        if self.editedFields.contains("Organization Name") && ((self.currentOrganizer.currentUserInformation.orgEvents!.count) != 0) {
            for event in currentOrganizer.currentUserInformation.orgEvents! {
                eventRef.document(event).updateData(["Organizer": self.currentOrganizer.currentUserInformation.name])
            }
        }
        userRef.updateData(["Organization Name": userInfo.name, "Organization Description": userInfo.description!, "Organization Website Link": userInfo.websiteLink!, "Email": userInfo.email, "Profile Pic URL": userInfo.profPicURL, "Organizer ID": userInfo.orgID!, "Number of Followers": userInfo.numberFollowers ?? 0])
        
    }
    
    private func getOrganizerEvents() {
        
        let database = Firestore.firestore()
        let eventRef = database.collection("Events")
        for event in currentOrganizer.currentUserInformation.orgEvents! {
            eventRef.document(event).getDocument() { (document, error) in
                if let document = document {
                    let id = document.documentID
                    let eventTitle = document.get("Name") as! String
                    let organizer = document.get("Organizer") as! String
                    let organizerID = document.get("Organizer ID") as! Int
                    let eventDescription = document.get("Description") as! String
                    let date = document.get("Date") as! String
                    let time = document.get("Time") as! String
                    let location = document.get("Location") as! String
                    let numAttending = document.get("Number Attending") as! Int
                    let eventPhotoURL = document.get("Event Photo URL") as! String
                    self.orgEvents.append(Event(id: id, eventTitle: eventTitle, eventOrganizer: organizer, eventOrganizerID: organizerID, eventDescription: eventDescription, date: date, time: time, location: location, numAttending: numAttending, eventPhotoURL: eventPhotoURL))
                } else {
                  print("Document does not exist")
                }
              }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        //print(eventManager.eventInformation[offsets.first!])
        let removedEvent = orgEvents[offsets.first!]
        orgEvents.remove(atOffsets: offsets)
        let database = Firestore.firestore()
        database.collection("Events").document(removedEvent.id).delete() { err in
            if let err = err {
                print("error")
            } else {
                print("success")
            }
        }
        let userRef = database.collection("Organizers").document(currentOrganizer.currentUserInformation.name)
        userRef.updateData(["Events": FieldValue.arrayRemove([removedEvent.id])])
    }
}


struct MyAccountActivistView: View {
    
    @EnvironmentObject var currentActivist: CurrentUser
    
    var body: some View {
        
        Text(self.currentActivist.currentUserInformation.name)
    }
}
    
struct MyAccount_Previews: PreviewProvider {
    static var previews: some View {
        MyAccount()
    }
}
