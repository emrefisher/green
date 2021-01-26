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
    
    var body: some View {
        
        VStack {
            ProgressView(value: CGFloat(self.organizerSignUpManager.pageNumber), total: 6) {
                HStack(alignment: .center) {
                    Text("Progress: (\(self.organizerSignUpManager.pageNumber)/6)")
                }
            }
            Spacer()
            Text("Enter Organization Name")
            TextField("Organization Name", text: self.$organizerSignUpManager.orgName).textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Enter Organization Website")
            TextField("Organization Website", text: self.$organizerSignUpManager.orgWebsite).textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                self.organizerSignUpManager.pageNumber -= 1
            }) {
                Text("Previous Page")
            }
            
            Button(action: {
                self.organizerSignUpManager.pageNumber += 1
            }) {
                Text("Next Page")
            }
            Spacer()
            
        }.padding(.horizontal, UIScreen.main.bounds.width/20)
        
    }
}

