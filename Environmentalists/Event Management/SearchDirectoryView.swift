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

struct FilterPage: View {
    
    @Binding var distance: Double
    
    var body: some View {
        
        VStack {
            Text("Distance")
            Text("(Within \(self.distance, specifier: "%.0f") miles)")
            Slider(value: $distance, in: 1...100, step: 1).padding(.horizontal, 25)
        }
    }
}

struct EventRow: View {
    
    @State var event: Event
    
    var body: some View {
        
        VStack {
                    HStack {
                        Image("mountain_landscape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: (UIScreen.main.bounds.width/10)*4, height: UIScreen.main.bounds.height/8, alignment: .leading)
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
                
                //                FindEventsViewTopBar(showMapView: $showMapView)
                
                List(eventManager.eventInformation) {Event in
                    NavigationLink(destination: EventPage(event: Event)) {
                        EventRow(event: Event)
                    }
                }
            }
            .navigationBarTitle("Search/Directory View", displayMode: .inline)
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

struct FindEventsViewTopBar: View {
    
    @State var searchText = ""
    @Binding var showMapView: Bool
    
    @State var showFilters = false
    @State var distance: Double = 1
    @State var eventType: [String] = [String]()
    @State var interest: [String] = [String]()
    @ObservedObject var searchBarInfo = SearchBarInformation()
    
    var body: some View {
        
        ZStack() {
            SearchBar(text: self.$searchText, searchData: self.$searchBarInfo.data)
            
//            HStack(spacing: 20) {
//                Picker(selection: $showMapView, label: Text(""), content: {
//                    Text("List View").tag(false)
//                    Text("Map View").tag(true)
//                }).pickerStyle(SegmentedPickerStyle())
//                .padding(.leading, 50)
//
//                Button(action: {
//                    self.showFilters.toggle()
//                }) {
//                    Image(systemName: "line.horizontal.3")
//                }.font(.system(size: 22.5))
//                .padding(.trailing, 25)
//                .sheet(isPresented: $showFilters) {
//                    FilterPage(distance: self.$distance)
//                }
//
//            }.padding(.top, 30)
            
        }.padding(.bottom, 15)
    }
}

struct EventPage: View {
    
    @State var event: Event
    
    var body: some View {
        
        
        VStack(spacing: 0){
            VStack {
                
                Image("mountain_landscape")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3)
                
                
            }
            
            VStack(spacing: 6) {
                
                Text("\(self.event.eventTitle)")
                    .font(.title)
                
                HStack {
                    VStack(alignment: .leading) {
                        NavigationLink(destination: OrgProfile(organizerID: self.event.eventOrganizerID)) {
                            Text("@\(self.event.eventOrganizer)")
                                .font(.headline)
                                .fontWeight(.regular)
                                .foregroundColor(Color.black.opacity(0.5))
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

            }
            Spacer()
        
        }.edgesIgnoringSafeArea(.all)
    }
}

class SearchBarInformation: ObservableObject {
    
    @Published var data = [String]()
    
    init() {
            
            let db = Firestore.firestore()
            
            db.collection("Organizers").getDocuments { (snap, err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    return
                }
                
                for i in snap!.documents{
                    
                    let id = i.documentID
                    
                    self.data.append(id)
                }
            }
        
        db.collection("Events").getDocuments { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documents{
                
                let id = i.get("Name") as! String
                
                self.data.append(id)
            }
        }
        }
}
struct SearchBar: View {
    
    @Binding var text: String
    @State var isSearching = false
    @Binding var searchData: [String]
    
    var body: some View {
        
        HStack {
            TextField("Search...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                 
                        if isSearching {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isSearching = true
                }
            
            if self.isSearching {
                Button(action: {
                    self.isSearching = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
            
//            if self.text != ""{
//
//                if  self.searchData.filter({$0.lowercased().contains(self.text.lowercased())}).count == 0 {
//
//                    Text("No Results Found").foregroundColor(Color.black.opacity(0.5)).padding()
//                }
//
//                else{
//
//                    List(self.searchData.filter{$0.lowercased().contains(self.text.lowercased())}) {i in
//
//                        HStack {
//                            Text(self.searchData[i])
//                        }
//
//
//                    }.frame(height: UIScreen.main.bounds.height / 5)
//                }
//
//            }
        }
    }
}

struct TabBar: View {
    
    @Binding var index: Int
    @State var geometryReader: GeometryProxy
    @State var showPopUpMenu = false
    
    var body: some View {
        
        ZStack {
            if self.showPopUpMenu {
                TabBarAdditionalMenu(index: self.$index)
                    .offset(y: -geometryReader.size.height/7)
            }
            HStack(spacing: 10) {
                
                VStack(spacing: 0) {
                    Button(action: {
                        
                        self.index = 1
                        
                    }) {
                        
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometryReader.size.width/3, height: 30)
                            .foregroundColor(self.index == 1 ? Color.green : Color.black.opacity(0.25))
                    }
                    Text("Find Events").font(.caption).foregroundColor(self.index == 1 ? Color.green : Color.black.opacity(0.25))
                }
                
                ZStack {
                    Circle()
                        .foregroundColor(Color.white)
                        .frame(width: 60, height: 60)
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)))
                        .rotationEffect(Angle(degrees: self.showPopUpMenu ? 180 : 0))
                }
                .offset(y: -geometryReader.size.height/9/2)
                .onTapGesture {
                    withAnimation {
                        self.showPopUpMenu.toggle()
                    }
                }
                
                VStack(spacing: 0) {
                    Button(action: {
                        
                        self.index = 2
                        
                    }) {
                        
                        Image(systemName: "calendar.badge.plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometryReader.size.width/3, height: 30)
                            .foregroundColor(self.index == 2 ? Color.green : Color.black.opacity(0.25))
                    }
                    Text("Create Event").font(.caption).foregroundColor(self.index == 2 ? Color.green : Color.black.opacity(0.25))
                }
                
            }
            .frame(width: geometryReader.size.width, height: geometryReader.size.height/9)
            .background(Color.white.shadow(radius: 2))
        }
    }
}

struct TabBarAdditionalMenu: View {
    
    @Binding var index: Int
    
    var body: some View {
        
        HStack(spacing: 75) {
            ZStack {
                Circle()
                    .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                    .frame(width: 50, height: 50)
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
            }
            .onTapGesture {
                self.index = 3
            }
            
            ZStack {
                Circle()
                    .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                    .frame(width: 50, height: 50)
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
            }
            .onTapGesture {
                self.index = 4
            }
        }
        .transition(.scale)
    }
}

struct OrgProfile: View {
    
    @State var organizerID: Int
    @ObservedObject var organizer = OrganizerInfo()
    
    var body: some View {
        
        if self.organizer.organizerInformation.orgWebsite == "" {
            self.organizer.getOrganizerInformation(organizationID: self.organizerID)
        }
        return VStack(spacing: 0){
            VStack {

                WebImage(url: URL(string: "\(self.organizer.organizerInformation.orgCoverPic)"))
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/5)
                    .aspectRatio(contentMode: .fit)

            }
            
                VStack(spacing: 5) {
            
                    WebImage(url: URL(string: "\(self.organizer.organizerInformation.orgProfilePic)"))
                        .resizable()
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 5))
                        .frame(width: UIScreen.main.bounds.height/8, height: UIScreen.main.bounds.height/8)

                    
//                    Circle()
//                        .fill(Image("propicwwf"))
//                        .frame(width: 125, height: 125)
//                        .overlay(Circle().stroke(Color.white, lineWidth: 5))
//                        .shadow(radius: 10)
//                        .offset(y: -62.5)
//                        .padding(.bottom, -60)
//
                    
                    Text(self.organizer.organizerInformation.organizerName)
                        .font(.headline)
                    
                    HStack(spacing: 25) {
                        Text(self.organizer.organizerInformation.orgDescription)
                            .font(.system(size: 10))
                            .fontWeight(.light)
                            .foregroundColor(Color.black)
                       
                    }
                    HStack(spacing: 25) {
                        
                        Link(destination: URL(string: "W")!) {
                            Image(systemName: "dollarsign.circle").resizable().frame(width: 35, height: 35).foregroundColor(.black)
                                .background(LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0, green: 0.9791811109, blue: 0.6578459144, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.6921610236, blue: 0, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(200)
                        }
                        
                     
                        
//                        Button(action: {
//
//                        }) {
//                            Text("Follow").font(.body)
//                                .foregroundColor(.black)
//                                .padding(.horizontal, 12.5)
//                                .padding(.vertical, 8.5)
//                        }.background(LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0, green: 0.9555450082, blue: 0.9714638591, alpha: 1)), Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
//                        .cornerRadius(25)
                        
                    }
                    HStack(spacing: 325) {
                        VStack(spacing: 100) {
                            HStack(spacing: 5) {
                                Image(systemName:"mappin.and.ellipse")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                Text(self.organizer.organizerInformation.orgLocation).font(.system(size: 10))
                            }
                        }
                        
                    }
                    
                    Text("\(self.organizer.organizerInformation.orgFollowers) Followers") .font(.system(size: 12)).bold()

                    
                }.offset(y: -UIScreen.main.bounds.height/16)
            
            Spacer()
            
        }
        .onAppear() {
            self.organizer.getOrganizerInformation(organizationID: self.organizerID)
        }
    }
}

struct SearchDirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchDirectoryView()
    }
}
