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

struct EventPage: View {
    
    @State var event: Event
    @State var rsvpEventClicked : Bool = false
    @EnvironmentObject var currentActivist: CurrentUser
    @State private var actEvents = [Event]()
    
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
                            NavigationLink(destination: OrgProfile(organizerID: self.event.eventOrganizerID)) {
                                Text("@\(self.event.eventOrganizer)")
                                    .font(.headline)
                                    .fontWeight(.regular)
                                    .foregroundColor(Color.black.opacity(0.5))
                            }
                            Spacer()
                                //Open to RSVP State
                                if (rsvpEventClicked == false) {
                                    Button("RSVP", action: {rsvpToggle(event: event, currentUser: self.currentActivist, rsvpEventClicked: &rsvpEventClicked)}).buttonStyle(openRSVP())
                                    
                                }
                                else {//Going State
                                    Button(action: {
                                        rsvpToggle(event: event, currentUser: self.currentActivist, rsvpEventClicked: &rsvpEventClicked)
                                    }) {
                                        HStack {
                                            Image(systemName: "checkmark")
                                            Text("Going")
                                                .font(.body)
                                        }
                                    }.buttonStyle(closedRSVP())
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
                            
                            Text("\(self.event.eventDescription)")
                                .font(.system(size: 12.5))
                            
                        }
                        Spacer()
                    }.padding(.horizontal, 30)
                    
                }.navigationBarTitle("", displayMode: .inline)
                Spacer()
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

func rsvpToggle(event: Event, currentUser: CurrentUser, rsvpEventClicked: inout Bool) {
    
    let activist = currentUser.currentActivistInformation.id
    let database = Firestore.firestore()
    let userRefA = database.collection("Activists")
    rsvpEventClicked.toggle()
    if (rsvpEventClicked == true) {
        userRefA.document(activist).updateData(["Events": FieldValue.arrayUnion([event.id])])
    }
    else {
        userRefA.document(activist).updateData(["Events": FieldValue.arrayRemove([event.id])])
    }
}
struct openRSVP: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .frame(width: UIScreen.main.bounds.size.width/5, height: UIScreen.main.bounds.size.height / 20)
            //.background(configuration.isPressed ? Color.orange : Color.green)
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

