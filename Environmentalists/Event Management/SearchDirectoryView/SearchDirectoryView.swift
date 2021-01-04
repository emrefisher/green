//
//  SearchDirectoryView.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/5/20.
//

import SwiftUI
import FirebaseFirestore
import MapKit
import SDWebImageSwiftUI

struct SearchDirectoryView: View {
    
    @EnvironmentObject var sessionManager: UserSessionManager
    @EnvironmentObject var currentUser: CurrentUser
    @State var showMapView = false
    
    var body: some View {
        ZStack {
            VStack {
                if showMapView {
                    MapView(showMapView: self.$showMapView)
                }
                else {
                    EventListView(showMapView: self.$showMapView)
                        .environmentObject(sessionManager)
                }
            }
        }
    }
}


struct EventRow: View {
    
    @State var event: Event
    
    var body: some View {
        
        VStack {
            HStack {
                WebImage(url: URL(string: self.event.eventPhotoURL))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: (UIScreen.main.bounds.width/10)*4, height: UIScreen.main.bounds.height/8, alignment: .leading)
                    .clipped()
                
                Spacer()
                
                VStack(alignment: .leading) {
                    HStack{
                        
                        Text(self.event.eventTitle)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                        
                        Spacer()
                    }
                    HStack{
                        
                        Text("\(self.event.date), \(self.event.time)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(#colorLiteral(red: 0.847653091, green: 0.4177049398, blue: 1, alpha: 1)))
                            .opacity(0.75)
                        
                        Spacer()
                    }
                    HStack{
                        
                        Text(self.event.location)
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundColor(Color.black)
                        
                        Spacer()
                    }
                    HStack{
                        
                        Text(self.event.eventOrganizer)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                        
                        Spacer()
                    }
                    Spacer()
                    
                    
                }
                .frame(width: (UIScreen.main.bounds.width/10)*6, height: UIScreen.main.bounds.height/8, alignment: .center)
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/8, alignment: .center)
    }
}

struct EventListView: View {
    
    @EnvironmentObject var sessionManager: UserSessionManager
    
    @Binding var showMapView: Bool
    
    @ObservedObject var eventManager = EventManager()
    
    var body: some View {
        
        NavigationView{
            VStack(spacing: 0) {
                
                FindEventsViewTopBar(showMapView: $showMapView, eventManager: self.eventManager)
                
                List(eventManager.eventInformation) {Event in
                    NavigationLink(destination: EventPage(event: Event)) {
                        EventRow(event: Event)
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        self.eventManager.clearEvents()
                                        self.eventManager.getEventInformation()
                                    }) {
                                        Image(systemName: "arrow.clockwise")
                                    })
            
        }            .onAppear() {
            if self.eventManager.eventInformation.count == 0 {
                self.eventManager.getEventInformation()
            }
        }
    }
}

struct SearchDirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchDirectoryView()
    }
}
