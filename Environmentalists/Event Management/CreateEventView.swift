//
//  CreateEventView.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/11/20.
//

import SwiftUI
import MapKit

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
    @State private var pickingLocation = false
    @State private var tapped = false
    @State private var search = ""
    @State private var landmarks: [Landmark] = [Landmark]()
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    
    var body: some View {
        ZStack {
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
                        if eventCreationManager.location == "" {
                            Button(action: {
                                pickingLocation.toggle()
                            }) {
                                Text("Set a Location")
                            }
                        }
                        else {
                            Button(action: {
                                pickingLocation.toggle()
                            }) {
                                Text(eventCreationManager.location)
                            }
                        }
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
            .opacity(pickingLocation ? 0 : 1)
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
            
            VStack {
                TextField("Search", text: $search)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                    .onChange(of: search, perform: { value in
                        getNearByLandmarks()
                    })

                
                PlaceListView(location: $eventCreationManager.location, pickingLocation: $pickingLocation, landmarks: landmarks) {
                    // on tap
                    self.tapped.toggle()
                }.animation(.spring())
                
            }.padding()
            .padding(.top, UIScreen.main.bounds.height/5)
            .background(Color.white)
            .opacity(pickingLocation ? 1 : 0)
            
            
        }
    }
    
    func loadImage() {
        guard let inputImage = self.eventCreationManager.pickedImage else {return}
        self.eventCreationManager.eventPic = inputImage
    }
    
    private func getNearByLandmarks() {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = search
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response {
                
                let mapItems = response.mapItems
                self.landmarks = mapItems.map {
                    Landmark(placemark: $0.placemark)
                }
                
            }
            
        }
        
    }
    
}

struct PlaceListView: View {
    
    @Binding var location: String
    @Binding var pickingLocation: Bool
    let landmarks: [Landmark]
    var onTap: () -> ()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            List {
                
                ForEach(self.landmarks, id: \.id) { landmark in
                    Button(action: {
                        location = landmark.name + " " + landmark.title
                        pickingLocation.toggle()
                    }) {
                        VStack(alignment: .leading) {
                            Text(landmark.name)
                                .fontWeight(.bold)
                            
                            Text(landmark.title)
                        }
                    }
                }
                
            }.animation(nil)
            
        }.cornerRadius(10)
    }
}

struct Landmark {
    
    let placemark: MKPlacemark
    
    var id: UUID {
        return UUID()
    }
    
    var name: String {
        self.placemark.name ?? ""
    }
    
    var title: String {
        self.placemark.title ?? ""
    }
    
    var coordinate: CLLocationCoordinate2D {
        self.placemark.coordinate
    }
}
