//
//  EventPage.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/3/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct EventPage: View {
    
    @State var event: Event
    
    var body: some View {
        
        
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

