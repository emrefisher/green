//
//  EventPage.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/3/21.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import MapKit
import CoreLocation

struct Marker: Identifiable {
    let id = UUID()
    var location: MapMarker
}

struct EventPage: View {
    
    @State var event: Event
    @State var rsvpEventClicked : Bool = false
    @State var navigatingThroughMyAccount: Bool
    @EnvironmentObject var currentUser: CurrentUser
    @State private var actEvents = [Event]()
    @State private var isAttending = false
    @ObservedObject var mapManager = MapManager()
    @Binding var eventClicked: Bool
    @State var orgPressed = false
    //@ObservedObject var num = monitorAttendees()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0){
                VStack {
                    
                    WebImage(url: URL(string: self.event.eventPhotoURL))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3)
                        .clipped()
                    
                }
                
                VStack(spacing: 6) {
                    
                    Text("\(self.event.eventTitle)")
                        .font(.title)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            
                            HStack {
                                NavigationLink(destination: OrgProfile(organizerID: self.event.eventOrganizerID, pressed: $orgPressed)) {
                                Text("@\(self.event.eventOrganizer)")
                                    .font(.headline)
                                    .fontWeight(.regular)
                                    .foregroundColor(Color.black.opacity(0.5))
                            }
                            Spacer()
                                
                                if self.currentUser.currentUserInformation.accountType == "Activist" {
                                //Open to RSVP State
                                    if self.isAttending == false {
                                        Button("RSVP", action: {rsvpToggle(isAttending: &self.isAttending)}).buttonStyle(openRSVP())
                                    
                                }
                                else {
                                    //Going State
                                    Button(action: {
                                        rsvpToggle(isAttending: &self.isAttending)
                                    }) {
                                        HStack {
                                            Image(systemName: "checkmark")
                                            Text("Going")
                                                .font(.body)
                                        }
                                    }.buttonStyle(closedRSVP())
                                }
                            }
                            }
                            
                            Link(destination: URL(string: "https://maps.apple.com/?address=\(self.event.location.replacingOccurrences(of: " ", with: "%20"))")!) {
                                HStack(spacing: 8) {
                                    
                                    Image(systemName:"mappin.and.ellipse")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                    Text("\(self.event.location)")
                                        .font(.system(size: 12.5))
                                }
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName:"timer")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                Text("\(self.event.date), \(self.event.time)")
                                    .font(.system(size: 12.5))
                            }
                            
                            Text("\(self.event.eventDescription)")
                                .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                                .font(.subheadline)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.dearthGreen, lineWidth: 1.2)
                                )

                            
                            VStack {
                                
                                Map(coordinateRegion: $mapManager.region,
                                    annotationItems: mapManager.markers ?? []) { marker in
                                           marker.location
                                }
                                }.frame(width: UIScreen.main.bounds.width*7/8, height: UIScreen.main.bounds.height/4)
                            
                            
                            
                            //                Button(action: {
                            //
                            //                }) {
                            //                    Text("RSVP").font(.body)
                            //                        .foregroundColor(.black)
                            //                        .padding(.horizontal, 12.5)
                            //                        .padding(.vertical, 8.5)
                            //                }
                            //                .background(LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)), Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                            //                .cornerRadius(25)
                            
                           /* Text("\(self.event.eventDescription)")
                                .font(.system(size: 12.5))*/
                            
                        }
                        Spacer()
                    }.padding(.horizontal, 30)
                    
                }.navigationBarTitle("", displayMode: .inline)
                Spacer()
            }
        }.edgesIgnoringSafeArea(.all)
        .onAppear() {
            eventClicked = true
            
            if self.currentUser.currentUserInformation.userEventIDs.contains(self.event.id) {
                self.isAttending = true
            }
            
            mapManager.getGeoLocation(event: event)
         
        }
        .onDisappear() {
            if orgPressed == false {
                eventClicked = false
            }
        }
        
    }
    
    private func rsvpToggle(isAttending: inout Bool) {
        
        let activist = self.currentUser.currentUserInformation.id
        //let eventId = event.id
        let database = Firestore.firestore()
        let userRefA = database.collection("Activists")
        //let eventRef = database.collection("Events")
        isAttending.toggle()
        if (isAttending == true) {
            //let num = event.numAttending + 1
            userRefA.document(activist).updateData(["Events": FieldValue.arrayUnion([event.id])])
            self.currentUser.currentUserInformation.userEventIDs.append(event.id)
            self.currentUser.currentUserInformation.userEvents.append(event)
            currentUser.getSortedEvents()
//            if self.navigatingThroughMyAccount == true {
//                self.currentUser.eventListChanged = true
//            }
           // eventRef.document(eventId).updateData(["Number Attending": num])
        }
        else {
            //let num = event.numAttending - 1
            userRefA.document(activist).updateData(["Events": FieldValue.arrayRemove([event.id])])
            if let index = currentUser.currentUserInformation.userEventIDs.firstIndex(of: event.id) {
                currentUser.currentUserInformation.userEventIDs.remove(at: index)
                currentUser.currentUserInformation.userEvents.remove(at: index)
            }
            currentUser.getSortedEvents()
            //eventRef.document(eventId).updateData(["Number Attending": num])
        }
    }
    
}
/*class monitorAttendees: ObservableObject {
    @Published var numAttending = 0
}*/
//func isEventRSVP(event: Event, currentUser: CurrentUser, rsvpEventClicked: inout Bool) {
//    currentUser.getUserInformation()
//    for actEvent in currentUser.currentUserInformation.userEventIDs {
//        if actEvent == event.id {
//            rsvpEventClicked = true
//        }
//    }
//}

struct openRSVP: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .frame(width: UIScreen.main.bounds.size.width/5, height: UIScreen.main.bounds.size.height / 20)
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
            .scaleEffect(configuration.isPressed ? 1.3 : 1.0)
            .clipShape(Capsule())
    }
}

struct closedRSVP: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .frame(width: UIScreen.main.bounds.size.width/3.5, height: UIScreen.main.bounds.size.height / 20)
            //.background(configuration.isPressed ? Color.orange : Color.green)
            //.background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
            .background(Color.green)
            .scaleEffect(configuration.isPressed ? 1.3 : 1.0)
            .clipShape(Capsule())
    }
}

class MapManager: ObservableObject {
    
    @Published var coordinates = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    @Published var markers: [Marker]?
    
    func getGeoLocation(event: Event) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(event.location) {
            placemarks, error in
            let placemark = placemarks?.first
            let locationLatitude = placemark?.location?.coordinate.latitude ?? 0.0
            let locationLongitude = placemark?.location?.coordinate.longitude ?? 0.0
            self.region.center.latitude = locationLatitude
            self.region.center.longitude = locationLongitude
            self.coordinates = CLLocationCoordinate2D(latitude: locationLatitude, longitude: locationLongitude)
            self.markers = [Marker(location: MapMarker(coordinate: self.coordinates, tint: .red))]
        }
    }
    
}
