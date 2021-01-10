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
                    
                    HStack(spacing: 25) {
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
                
            }.navigationBarTitle("", displayMode: .inline)

        }
        
        else {
            
            VStack {
                TextField("Organization Name", text: self.$currentOrganizer.currentUserInformation.name, onEditingChanged: { _ in
                    self.editedFields.append("Organization Name")
                })
                
                Button(action: {
                    print(self.editedFields)
                    updateOrganizerInFirebase()
                    self.isEditingProfile.toggle()
                }) {
                    Text("Save Changes")
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
