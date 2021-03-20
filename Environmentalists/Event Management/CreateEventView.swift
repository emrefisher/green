//
//  CreateEventView.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/11/20.
//

import SwiftUI

enum AlertState {
    case validation, confirmation
}

struct CreateEventView: View {
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var eventCreationManager = EventCreationManager(titleLimit: 30, descriptionLimit: 500)
    @EnvironmentObject var currentUser: CurrentUser
    @State var eventDate = Date()
    @State private var alertState: AlertState = .confirmation
    @State private var showEventPicker = false
    @State private var showActionSheet = false
    @State private var createEventClicked = false
    @State private var completionAlert = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    
    var body: some View {
            VStack(spacing: 0) {
                
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle").font(.system(size: 25))
                    }
                }.padding(.trailing, 25)
                
                Button(action: {
                    
                    self.showActionSheet.toggle()
                    
                }) {
                    
                    if self.eventCreationManager.eventimagedata.count == 0 {
                        ZStack {
                            Rectangle()
                                .fill(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 4, alignment: .center)
                            VStack {
                                Image(systemName: "camera.on.rectangle").resizable().frame(width: 90, height: 70).foregroundColor(.black)
                                Text("Add Photo").foregroundColor(.black)
                            }
                        }
                    }
                    else{
                        Image(uiImage: UIImage(data: self.eventCreationManager.eventimagedata)!)
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 4, alignment: .center)
                            .clipped()
                    }
                    
                }.sheet(isPresented: self.$showEventPicker, content: {
                    
                    ImagePicker(pickedImage: self.$eventCreationManager.pickedImage, showImagePicker: self.$showEventPicker, imageData: self.$eventCreationManager.eventimagedata, sourceType: self.$sourceType)
                    
                })
                .actionSheet(isPresented: self.$showActionSheet) {
                    ActionSheet(title: Text(""), buttons: [
                                    .default(Text("Choose a Photo")) {
                                        self.sourceType = .photoLibrary
                                        self.showEventPicker = true
                                    },
                                    .default(Text("Take a Photo")) {
                                        self.sourceType = .camera
                                        self.showEventPicker = true
                                    },
                        .cancel()
                    ])
                }
                
                Form {
                    
                    Section(header: Text("Event Name")) {
                        TextField("", text: self.$eventCreationManager.title)
                        
                    }
                    
                    Section(header: Text("Event Description")) {
                        TextEditor(text: self.$eventCreationManager.description)
                            .keyboardType(.asciiCapable)
                    }
                    
                    Section(header: Text("Location")) {
                        TextField("", text: self.$eventCreationManager.location).disableAutocorrection(true)
                            .keyboardType(.asciiCapable)
                    }
                    
                    Section(header: Text("Date and Time")) {
                        DatePicker("Date", selection: $eventDate, in: Date()..., displayedComponents: .date)
                        DatePicker("Time", selection: $eventDate, displayedComponents: .hourAndMinute)
                    }
                    
                    Section(footer:
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        if self.eventCreationManager.validateEventFields(date: self.eventDate) != nil {
                                            self.alertState = .validation
                                        }
                                        self.createEventClicked.toggle()
                                    }) {
                                        Text("Create Event")
                                            .foregroundColor(.white).frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.width / 9).background(Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))).clipShape(Capsule())
                                    }
                                    Spacer()
                                }) {
                        
                    }.alert(isPresented: self.$createEventClicked) {
                        switch alertState {
                        case .validation:
                            return Alert(title: Text("Event Creation Error"), message: Text(self.eventCreationManager.errorMessage), dismissButton: .default(Text("OK")))
                        case .confirmation:
                            return Alert(title: Text("Confirmation"), message: Text("Are you sure all the information for your event is correct?"), primaryButton: .destructive(Text("Yes"), action: {
                                self.eventCreationManager.publishNewEvent(currentUser: self.currentUser, date: self.eventDate)
                                self.completionAlert.toggle()
                            }), secondaryButton: .cancel(Text("No"))
                            )
                        }
                        
                    }
                    
                }.frame(height: UIScreen.main.bounds.height/1.75)
                
        }.edgesIgnoringSafeArea(.all)
            .background(Color.gray.opacity(0.25))
            .navigationBarItems(leading: SearchDirectoryView())
        .onAppear() {
            self.eventCreationManager.clearEventData()
        }
        .alert(isPresented: self.$completionAlert) {
            Alert(title: Text(""), message: Text("Event Created Successfully"), dismissButton: .default(Text("OK"), action: {
                self.eventDate = Date()
                self.eventCreationManager.clearEventData()
                presentationMode.wrappedValue.dismiss()
            }))
        }
            .navigationBarItems(trailing: NavigationLink(destination: SearchDirectoryView()) {
        Image(systemName: "arrow.left").font(.largeTitle).foregroundColor(.black)
    })
        
    }
    
    func loadImage() {
        guard let inputImage = self.eventCreationManager.pickedImage else {return}
        self.eventCreationManager.eventPic = inputImage
    }
    
}

//struct CreateEventView: View {
//
//    @ObservedObject var eventCreationManager = EventCreationManager()
//    @EnvironmentObject var currentUser: CurrentUser
//    @State var completionAlert = false
//
//    var body: some View {
//        ZStack {
//            switch self.eventCreationManager.creationPageIndex {
//            case 0:
//                CreateEventPage1(eventCreationManager: self.eventCreationManager)
//            case 1:
//                CreateEventPage2(eventCreationManager: self.eventCreationManager)
//            case 2:
//                CreateEventPage3(eventCreationManager: self.eventCreationManager, completionAlert: self.$completionAlert)
//                    .environmentObject(self.currentUser)
//            default:
//                Text("Default")
//            }
//        }.onAppear() {
//            self.eventCreationManager.clearEventData()
//        }
//        .alert(isPresented: self.$completionAlert) {
//            Alert(title: Text(""), message: Text("Event Created Successfully"), dismissButton: .default(Text("OK"), action: { self.eventCreationManager.clearEventData()
//            }))
//        }
//    }
//}
//
//struct CreateEventPage1: View {
//
//    @ObservedObject var eventCreationManager: EventCreationManager
//
//    var body: some View {
//
//        ZStack {
//
////            LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)), Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
//
//            VStack(alignment: .center) {
//                Text("Create New Event").font(.title).padding(.bottom, 25)
//                VStack(){
//                    VStack {
//                        VStack(alignment: .leading) {
//                            Text("Title")
//                                .foregroundColor(Color.black)
//                                .font(.body)
//
//                            TextField("Enter your event title here...", text: self.$eventCreationManager.title)
//                        }
//                        VStack(alignment: .leading) {
//                            Text("Description")
//                                .font(.body)
//                            TextField("Enter brief event description here...", text: self.$eventCreationManager.description)
//
//                        }
//                    }
//                }
//
//            }.padding(.horizontal, 25)
//
//
//            VStack {
//                Spacer()
//                HStack {
////                    Button(action: {
////                        self.sessionIndex = 0
////                    }) {
////                        Text("Cancel").font(.body)
////                            .foregroundColor(.white)
////                            .padding(.horizontal, 12.5)
////                            .padding(.vertical, 8.5)
////                            .background(Color.black)
////                    }
//                    Spacer()
//                    Button(action: {
//                        self.eventCreationManager.creationPageIndex += 1
//                    }) {
//                        Text("Next").font(.body)
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 12.5)
//                            .padding(.vertical, 8.5)
//                            .background(Color.black)
//                    }
//                }.padding(.horizontal, 25)
//            }.padding(.bottom, 50)
//
//        }
//
//    }
//}
//
//struct CreateEventPage2: View {
//
//    @ObservedObject var eventCreationManager: EventCreationManager
//    @State private var coverpicker = false
//
//    var body: some View {
//
//        ZStack {
//
////            LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)), Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
//
//            VStack(alignment: .center) {
//                Text("Create New Event").font(.title).padding(.bottom, 25)
//                VStack(){
//                    VStack {
//                        VStack(alignment: .leading) {
//                            Text("Location")
//                                .foregroundColor(Color.black)
//                                .font(.body)
//
//                            TextField("Enter the location of your event here...", text: self.$eventCreationManager.location)
//                        }
//                        VStack(alignment: .leading) {
//                            Text("Date & Time")
//                                .font(.body)
//                            TextField("Enter Date & Time here...", text: self.$eventCreationManager.date)
//                            TextField("Enter Time here...", text: self.$eventCreationManager.time)
//
//                        }
//                        HStack{
//
//                            Spacer()
//
//
//                            Button(action: {
//
//                                self.coverpicker.toggle()
//
//                            }) {
//
//                                if self.eventCreationManager.coverimagedata.count == 0{
//
//                                    Image(systemName: "camera.on.rectangle").resizable().frame(width: 90, height: 70).foregroundColor(.gray)
//                                }
//                                else{
//
//                                    Image(uiImage: UIImage(data: self.eventCreationManager.coverimagedata)!).resizable().renderingMode(.original).frame(width: 90, height: 90)
//                                }
//
//
//                            }.sheet(isPresented: self.$coverpicker, content: {
//
//                                ImagePicker(picker: self.$coverpicker, imagedata: self.$eventCreationManager.coverimagedata)
//
//                            })
//
//                            Spacer()
//                        }
//
//                    }
//                }
//            }.padding(.horizontal, 25)
//
//            VStack() {
//                Spacer()
//                HStack {
//                    Button(action: {
//                        self.eventCreationManager.creationPageIndex -= 1
//                    }) {
//                        Text("Back").font(.body)
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 12.5)
//                            .padding(.vertical, 8.5)
//                            .background(Color.black)
//                    }
//                    Spacer()
//                    Button(action: {
//                        self.eventCreationManager.creationPageIndex += 1
//                    }) {
//                        Text("Next").font(.body)
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 12.5)
//                            .padding(.vertical, 8.5)
//                            .background(Color.black)
//                    }
//                }
//            }.padding(.horizontal, 25)
//
//        }.padding(.bottom, 50)
//
//    }
//}
//
//struct CreateEventPage3: View {
//
//    @ObservedObject var eventCreationManager: EventCreationManager
//    @Binding var completionAlert: Bool
//    @EnvironmentObject var currentUser: CurrentUser
//
//    var body: some View {
//
//        ZStack {
////
////            LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)), Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
//
//
//            VStack() {
////                Image("\(self.eventCreationManager.coverimagedata)")
////                .resizable()
////                .scaledToFit()
////                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/5)
//                Text("Review your submission...").font(.title)
//                Text(self.eventCreationManager.title).font(.body)
//                Text(self.eventCreationManager.description).font(.body)
//                Text(self.eventCreationManager.location).font(.body)
//                Text("\(self.eventCreationManager.date), \(self.eventCreationManager.time)").font(.body)
//
//                Spacer()
//                HStack {
//                    Button(action: {
//                        self.eventCreationManager.creationPageIndex -= 1
//                    }) {
//                        Text("Back").font(.body)
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 12.5)
//                            .padding(.vertical, 8.5)
//                            .background(Color.black)
//                    }
//                    Spacer()
//                    Button(action: {
//                        self.eventCreationManager.publishNewEvent(currentUser: self.currentUser)
//                        self.completionAlert.toggle()
//                    }) {
//                        Text("Publish Event").font(.body)
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 12.5)
//                            .padding(.vertical, 8.5)
//                            .background(Color.black)
//                    }
//                }.padding(.horizontal, 25)
//
//            }
//
//
//
//        }.padding(.bottom, 50)
//
//    }
//}
//
