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
    @State var orgEvents = [Event]()
    @State private var eventIndex = 0
    private let dateRange = ["Upcoming", "Past"]
    
    var body: some View {

        if currentOrganizer.currentUserInformation.userEvents.count != currentOrganizer.currentUserInformation.userEventIDs.count {
            currentOrganizer.getUserEvents() { _ in
                currentOrganizer.getSortedEvents()
            }
        }
        return ZStack {
        if isEditingProfile == false {
            NavigationView {
            VStack(spacing: 0){

                VStack {


                    if ( self.currentOrganizer.currentUserInformation.coverPhotoURL != "") {
                    WebImage(url: URL(string: "\(self.currentOrganizer.currentUserInformation.coverPhotoURL)"))
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/5)
                        .aspectRatio(contentMode: .fit)
                    }
                    else {
                        Image("mountain_landscape")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/5)
                            .aspectRatio(contentMode: .fit)
                    }

                }

                VStack(spacing: 5) {

                    HStack {
                    WebImage(url: URL(string: "\(self.currentOrganizer.currentUserInformation.profPicURL)"))
                        .resizable()
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.green, lineWidth: 5))
                        .frame(width: UIScreen.main.bounds.height/8, height: UIScreen.main.bounds.height/8, alignment: .leading)
                        .padding()

                        Spacer()
                        let completeURL = "https://" + self.currentOrganizer.currentUserInformation.websiteLink!
                        let url = URL(string:  completeURL)
                        if url == nil {
                            Text("Link not yet loaded")
                        }
                        else  {
                                Button(action: {
                                    UIApplication.shared.open(url!)
                                }) {
                                    Text("Donate")
                                        .frame(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/60)
                                        .foregroundColor(Color.white)
                                }
                                .padding(UIScreen.main.bounds.width/50)
                                .background(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))).clipShape(Capsule())
                                .offset(x: -UIScreen.main.bounds.width/50 )


                        }

                        Button(action: {
                            self.isEditingProfile.toggle()
                        }) {
                            Text("Edit Profile")
                                .frame(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/60)
                                .foregroundColor(Color.white)
                        }
                        .padding(UIScreen.main.bounds.width/50)
                        .background(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))).clipShape(Capsule())
                        .offset(x: -UIScreen.main.bounds.width/50 )
                    }
                    HStack {
                    Text(self.currentOrganizer.currentUserInformation.name)
                        .font(.headline)
                        Spacer()

                    }.offset(x: UIScreen.main.bounds.width/32)

                    HStack(spacing: 25) {
                        Text(self.currentOrganizer.currentUserInformation.description!)
                            .font(.system(size: 10))
                            .fontWeight(.light)
                            .foregroundColor(Color.black)
                        Spacer()
                    }.offset(x: UIScreen.main.bounds.width/32)

                    VStack() {


                      /*  HStack {
                                HStack(spacing: 5) {
                                    Image(systemName:"mappin.and.ellipse")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                    Text(self.currentOrganizer.currentUserInformation.location!).font(.system(size: 10))
                                }
                            Spacer()
                        }.offset(x: UIScreen.main.bounds.width/32)*/

                       /* HStack {
                        Text("\(self.currentOrganizer.currentUserInformation.numberFollowers ?? 0) Followers") .font(.system(size: 12)).bold()
                            Spacer()
                        }.offset(x: UIScreen.main.bounds.width/32)*/

                    }
                }.offset(y: -UIScreen.main.bounds.height/16)

                //Spacer()

                Picker("", selection: $eventIndex) {
                    ForEach(0..<2) {
                        Text(dateRange[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 25)
                Spacer()
                
                
                List {
                    ForEach((eventIndex == 0) ? currentOrganizer.upcomingEvents : currentOrganizer.pastEvents) { Event in
                        NavigationLink(destination: EventPage(event: Event, navigatingThroughMyAccount: true, eventClicked: .constant(false))) {
                            
                            EventRow(event: Event)
                            
                            
                        }
                    }
                }.listStyle(PlainListStyle())

            }.navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: Settings()) {
                Image(systemName: "gear").font(.largeTitle).foregroundColor(.black)
            })
            }
            .onAppear() {
//                if currentOrganizer.currentUserInformation.userEvents.count != currentOrganizer.currentUserInformation.userEventIDs.count {
//                    currentOrganizer.getUserEvents()
//                }
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
                Section(header: Text("Organization Website")) {
                    TextField("", text: (self.$currentOrganizer.currentUserInformation.websiteLink.bound), onEditingChanged: { _ in
                        self.editedFields.append("Organization Website Link")
                    }
                    )}

            }
            
            VStack {
                Spacer()
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
    }
    }
    
    private func updateOrganizerInFirebase() {
        
        let database = Firestore.firestore()
        let userInfo = currentOrganizer.currentUserInformation
        let eventRef = database.collection("Events")
        let userRef = database.collection("Organizers").document(userInfo.id)
        if self.editedFields.contains("Organization Name") && ((self.currentOrganizer.currentUserInformation.userEventIDs.count) != 0) {
            for event in currentOrganizer.currentUserInformation.userEventIDs {
                eventRef.document(event).updateData(["Organizer": self.currentOrganizer.currentUserInformation.name])
            }
        }
        userRef.updateData(["Organization Name": userInfo.name, "Organization Description": userInfo.description!, "Organization Website Link": userInfo.websiteLink!, "Email": userInfo.email, "Profile Pic URL": userInfo.profPicURL, "Organizer ID": userInfo.orgID!, "Number of Followers": userInfo.numberFollowers ?? 0])
        
    }
    
    private func getOrganizerEvents() {
        
        let database = Firestore.firestore()
        let eventRef = database.collection("Events")
        for event in currentOrganizer.currentUserInformation.userEventIDs {
            eventRef.document(event).getDocument() { (document, error) in
                if let document = document {
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
                    self.orgEvents.append(Event(id: id, eventTitle: eventTitle, eventOrganizer: organizer, eventOrganizerID: organizerID, eventDescription: eventDescription, date: date, time: time, location: location, numAttending: numAttending, eventPhotoURL: eventPhotoURL))
                } else {
                  print("Document does not exist")
                }
              }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        let removedEvent = orgEvents[offsets.first!]
        orgEvents.remove(atOffsets: offsets)
        let database = Firestore.firestore()
        database.collection("Events").document(removedEvent.id).delete() { err in
            if let err = err {
                print(err)
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
    @State private var isEditingProfile = false
    @State private var isUpcomingEvents = true
    @State private var eventIndex = 0
    private let dateRange = ["Upcoming", "Past"]
    @State private var editedFields = [String]()
    @State private var refreshedPage = false
    
    var body: some View {
        
        if currentActivist.currentUserInformation.userEvents.count != currentActivist.currentUserInformation.userEventIDs.count {
            currentActivist.getUserEvents() { _ in
                currentActivist.getSortedEvents()
            }
        }
        
        return VStack {
        if isEditingProfile == false {
            
            NavigationView {
                    
                VStack(spacing: 0){
                    
                    RandomCoverPhoto()
                    
                    VStack(spacing: 0) {
                        
                        HStack {
                            WebImage(url: URL(string: "\(self.currentActivist.currentUserInformation.profPicURL)"))
                                .resizable()
                                .shadow(color: Color.green, radius: 10)
                                .overlay(Circle().stroke(Color.gray, lineWidth: 5))
                                .frame(width: UIScreen.main.bounds.height/8, height: UIScreen.main.bounds.height/8, alignment: .leading)
                                .clipShape(Circle())
                                .offset(y: -UIScreen.main.bounds.height/12)
                                .padding()
                            
                            Spacer()
                            
                        }
                        HStack {
                            
                            Text("Welcome back \(self.currentActivist.currentUserInformation.name)!")
                                .font(.headline)
                            Spacer()
                            
                        }.offset(x: UIScreen.main.bounds.width/32)
                        Spacer()
                        
                        
                        Picker("", selection: $eventIndex) {
                            ForEach(0..<2) {
                                Text(dateRange[$0])
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 25)
                        
                        
                        List {
                            ForEach((eventIndex == 0) ? currentActivist.upcomingEvents : currentActivist.pastEvents) { Event in
                                NavigationLink(destination: EventPage(event: Event, navigatingThroughMyAccount: true, eventClicked: .constant(false))) {
                                    
                                    EventRow(event: Event)
                                    
                                }
                            }
                        }.listStyle(PlainListStyle())
                        
                        
                    }.navigationBarTitle("", displayMode: .inline)
                    .navigationBarItems(trailing: NavigationLink(destination: Settings()) {
                        Image(systemName: "gear").font(.largeTitle).foregroundColor(.black)
                    })
                    
                }
                
                
            }
        }
        else {
            
            Form {
                
                Section(header: Text("Activist Name")) {
                    TextField("", text: self.$currentActivist.currentUserInformation.name, onEditingChanged: { _ in
                        self.editedFields.append("Organization Name")
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
                        //updateActivistInFirebase()
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
//        }.onAppear() {
//            if currentActivist.currentUserInformation.userEvents.count != currentActivist.currentUserInformation.userEventIDs.count {
//                refreshedPage.toggle()
//            }
//        }
    }
    
    struct RandomCoverPhoto: View {
        
        @State var randomCoverPhoto = Int.random(in: 0..<5)
        @State private var nationalParks = ["deathValley", "gatesArctic", "olympic", "redwood", "yosemite", "zion"]
        
        var body: some View {
            
            Image(nationalParks[randomCoverPhoto])
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/5)
                .aspectRatio(contentMode: .fit)
            
        }
        
    }
    
    /* private func updateActivistInFirebase() {
     
     let database = Firestore.firestore()
     let userInfo = currentActivist.currentUserInformation
     let eventRef = database.collection("Events")
     let userRef = database.collection("Activists").document(userInfo.id)
     if self.editedFields.contains("First Name") && ((self.currentOrganizer.currentUserInformation.orgEvents!.count) != 0) {
     for event in currentOrganizer.currentUserInformation.orgEvents! {
     eventRef.document(event).updateData(["Organizer": self.currentOrganizer.currentUserInformation.name])
     }
     }
     userRef.updateData(["Organization Name": userInfo.name, "Organization Description": userInfo.description!, "Organization Website Link": userInfo.websiteLink!, "Email": userInfo.email, "Profile Pic URL": userInfo.profPicURL, "Organizer ID": userInfo.orgID!, "Number of Followers": userInfo.numberFollowers ?? 0])
     
     }*/
    
    private func getSortedEvent(actEvents: [Event]) -> [String: [Event]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM dd, yyyy"
        let events = actEvents
        var pastEvents = [Event]()
        var futureEvents = [Event]()
        let now = Date()
        for event in events {
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
        let sortedFutureEvents = futureEvents.sorted(by: {
            $0.date.compare($1.date) == .orderedAscending
        })
        
        return ["Past": sortedPastEvents, "Upcoming": sortedFutureEvents]
    }

}
    
struct MyAccount_Previews: PreviewProvider {
    static var previews: some View {
        MyAccount()
            
    }
}
