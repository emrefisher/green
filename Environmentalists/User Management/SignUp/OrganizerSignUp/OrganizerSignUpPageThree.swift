//
//  OrganizerSignUpPageThree.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/25/21.
//

import SwiftUI
import Foundation
import Combine

struct OrganizerSignUpPageThree: View {
    @ObservedObject var organizerSignUpManager: OrganizerSignUpManager
    @State private var alert = false
    
    var body: some View {
        
        VStack (spacing: 15) {
            ProgressView(value: CGFloat(self.organizerSignUpManager.pageNumber), total: 7) {
                HStack(alignment: .center) {
                    Text("Progress: (\(self.organizerSignUpManager.pageNumber)/7)")
                }
            }
            Spacer()
            Text("Name and Website").font(.largeTitle).padding(.bottom, 15)
            Text("Please provide us with general information about your organization to help activists get connected faster.").font(.caption).foregroundColor(.black).padding(.horizontal, 15).padding(.bottom, 15)
            Text("Enter Organization Name")
            TextField("Organization Name", text: self.$organizerSignUpManager.orgName).textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 30)
            Text("Enter Organization Website")
            TextField("Organization Website", text: self.$organizerSignUpManager.orgWebsite).textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 30)
                .padding(.bottom, 15)
            HStack {
                Button("← Back", action: {
                    self.organizerSignUpManager.pageNumber -= 1
                }).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.05 ).background(Color.fireOrange).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
                
                Button("Next →", action: {
                    if !self.organizerSignUpManager.orgName.isEmpty {
                        self.organizerSignUpManager.pageNumber += 1
                    }
                    else {
                        self.alert.toggle()
                    }
                }).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.05 ).background(Color.earthGreen).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
            }
            Spacer()
            
        }.alert(isPresented: self.$alert) {
            Alert(title: Text(""), message: Text("Please fill in your Organization's Name"), dismissButton: .default(Text("OK")))
        }.padding(.horizontal, UIScreen.main.bounds.width/20).padding(.vertical, UIScreen.main.bounds.height/10)
        
    }
}

