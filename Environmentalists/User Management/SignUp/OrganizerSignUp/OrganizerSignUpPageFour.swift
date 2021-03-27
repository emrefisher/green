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
        
        VStack (spacing: 15) {
            ProgressView(value: CGFloat(self.organizerSignUpManager.pageNumber), total: 7) {
                HStack(alignment: .center) {
                    Text("Progress: (\(self.organizerSignUpManager.pageNumber)/7)")
                }
            }
            Spacer()
            Text("Description").font(.largeTitle).padding(.vertical, 15)
            Text("Please provide a brief description of what your organization does to help the environment and what activists might find when attending your events.").font(.caption).foregroundColor(.black).padding(.horizontal, 15).padding(.bottom, 15)
            Text("Enter Organization Description")
            TextEditor(text: self.$organizerSignUpManager.orgDescription).textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height/4).overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray, lineWidth: 1)
            ).padding(.bottom, 15).font(.caption)
            HStack {
                Button("← Back", action: {
                    self.organizerSignUpManager.pageNumber -= 1
                }).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.05 ).background(Color.fireOrange).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
                
                Button("Next →", action: {
                    self.organizerSignUpManager.pageNumber += 1
                    }).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.05 ).background(Color.earthGreen).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
            }
            Spacer()
        }.padding(.horizontal, UIScreen.main.bounds.width/20).padding(.vertical, UIScreen.main.bounds.height/10)
        
    }
}

