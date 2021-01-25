//
//  OrganizerSignUpPageFour.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/25/21.
//

import SwiftUI

struct OrganizerSignUpPageFour: View {
    @ObservedObject var organizerSignUpManager: OrganizerSignUpManager
    
    var body: some View {
        
        VStack {
            ProgressView(value: CGFloat(self.organizerSignUpManager.pageNumber), total: 5) {
                HStack(alignment: .center) {
                    Text("Progress: (\(self.organizerSignUpManager.pageNumber)/5)")
                }
            }
            Spacer()
            Text("Enter Organization Description")
            TextEditor(text: self.$organizerSignUpManager.orgDescription).textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height/3)
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

