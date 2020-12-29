//
//  CreateEventView.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/11/20.
//

import SwiftUI

struct CreateEventView: View {
    
    @ObservedObject var eventCreationManager = EventCreationManager()
    @EnvironmentObject var currentUser: CurrentUser
    @State var showPublishCompletionAlert = false
    @State var showAuthorizationAlert = false
    
    var body: some View {
        ZStack {
            switch self.eventCreationManager.creationPageIndex {
            case 0:
                CreateEventPage1(eventCreationManager: self.eventCreationManager)
            case 1:
                CreateEventPage2(eventCreationManager: self.eventCreationManager)
            case 2:
                CreateEventPage3(eventCreationManager: self.eventCreationManager, completionAlert: self.$showPublishCompletionAlert)
                    .environmentObject(self.currentUser)
            default:
                Text("Default")
            }
        }.onAppear() {
            self.eventCreationManager.clearEventData()
            if self.currentUser.currentUserInformation.accountType != "Organizer" {
                self.showAuthorizationAlert.toggle()
            }
        }
        .alert(isPresented: self.$showPublishCompletionAlert) {
            Alert(title: Text(""), message: Text("Event Created Successfully"), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: self.$showAuthorizationAlert) {
            Alert(title: Text("Authorization Alert"), message: Text("You are not authorized to create events. Please exit this page"), dismissButton: .default(Text("I understand")))
        }
    }
}

struct CreateEventPage1: View {
    
    @ObservedObject var eventCreationManager: EventCreationManager
    
    var body: some View {
        
        ZStack {
            
//            LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)), Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                Text("Create New Event").font(.title).padding(.bottom, 25)
                VStack(){
                    VStack {
                        VStack(alignment: .leading) {
                            Text("Title")
                                .foregroundColor(Color.black)
                                .font(.body)
                            
                            TextField("Enter your event title here...", text: self.$eventCreationManager.title)
                        }
                        VStack(alignment: .leading) {
                            Text("Description")
                                .font(.body)
                            TextField("Enter brief event description here...", text: self.$eventCreationManager.description)
                            
                        }
                    }
                }
                
            }.padding(.horizontal, 25)
            
            
            VStack {
                Spacer()
                HStack {
//                    Button(action: {
//                        self.sessionIndex = 0
//                    }) {
//                        Text("Cancel").font(.body)
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 12.5)
//                            .padding(.vertical, 8.5)
//                            .background(Color.black)
//                    }
                    Spacer()
                    Button(action: {
                        self.eventCreationManager.creationPageIndex += 1
                    }) {
                        Text("Next").font(.body)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12.5)
                            .padding(.vertical, 8.5)
                            .background(Color.black)
                    }
                }.padding(.horizontal, 25)
            }.padding(.bottom, 50)
            
        }
        
    }
}

struct CreateEventPage2: View {
    
    @ObservedObject var eventCreationManager: EventCreationManager
    
    var body: some View {
        
        ZStack {
            
//            LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)), Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                Text("Create New Event").font(.title).padding(.bottom, 25)
                VStack(){
                    VStack {
                        VStack(alignment: .leading) {
                            Text("Location")
                                .foregroundColor(Color.black)
                                .font(.body)
                            
                            TextField("Enter the location of your event here...", text: self.$eventCreationManager.location)
                        }
                        VStack(alignment: .leading) {
                            Text("Date & Time")
                                .font(.body)
                            TextField("Enter Date & Time here...", text: self.$eventCreationManager.date)
                            TextField("Enter Time here...", text: self.$eventCreationManager.time)
                            
                        }
                        
                    }
                }
            }.padding(.horizontal, 25)
            
            VStack() {
                Spacer()
                HStack {
                    Button(action: {
                        self.eventCreationManager.creationPageIndex -= 1
                    }) {
                        Text("Back").font(.body)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12.5)
                            .padding(.vertical, 8.5)
                            .background(Color.black)
                    }
                    Spacer()
                    Button(action: {
                        self.eventCreationManager.creationPageIndex += 1
                    }) {
                        Text("Next").font(.body)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12.5)
                            .padding(.vertical, 8.5)
                            .background(Color.black)
                    }
                }
            }.padding(.horizontal, 25)
            
        }.padding(.bottom, 50)
        
    }
}

struct CreateEventPage3: View {
    
    @ObservedObject var eventCreationManager: EventCreationManager
    @Binding var completionAlert: Bool
    @EnvironmentObject var currentUser: CurrentUser
    
    var body: some View {
        
        ZStack {
//
//            LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)), Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            
            VStack() {
                Image("mountain_landscape")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/5)
                Text("Review your submission...").font(.title)
                Text(self.eventCreationManager.title).font(.body)
                Text(self.eventCreationManager.description).font(.body)
                Text(self.eventCreationManager.location).font(.body)
                Text("\(self.eventCreationManager.date), \(self.eventCreationManager.time)").font(.body)
                
                Spacer()
                HStack {
                    Button(action: {
                        self.eventCreationManager.creationPageIndex -= 1
                    }) {
                        Text("Back").font(.body)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12.5)
                            .padding(.vertical, 8.5)
                            .background(Color.black)
                    }
                    Spacer()
                    Button(action: {
                        if self.currentUser.currentUserInformation.accountType == "Organizer" {
                            self.eventCreationManager.publishNewEvent(currentUser: self.currentUser)
                            self.eventCreationManager.clearEventData()
                        }
                        self.completionAlert.toggle()
                    }) {
                        Text("Publish Event").font(.body)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12.5)
                            .padding(.vertical, 8.5)
                            .background(Color.black)
                    }
                }.padding(.horizontal, 25)
                
            }
            
            
            
        }.padding(.bottom, 50)
        
    }
}

