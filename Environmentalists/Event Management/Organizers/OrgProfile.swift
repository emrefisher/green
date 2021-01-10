//
//  OrgProfile.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/3/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct OrgProfile: View {
    
    @State var organizerID: String
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
                        let completeURL = "https://" + self.organizer.organizerInformation.orgWebsite
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

