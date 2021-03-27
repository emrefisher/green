//
//  OrganizerSignUpPageSeven.swift
//  Environmentalists
//
//  Created by William Kraft on 3/27/21.
//

import SwiftUI

struct OrganizerSignUpPageSeven: View {
    @ObservedObject var organizerSignUpManager: OrganizerSignUpManager
    
    var body: some View {
        
        VStack (spacing: 15) {
            ProgressView(value: CGFloat(self.organizerSignUpManager.pageNumber), total: 7) {
                HStack(alignment: .center) {
                    Text("Progress: (\(self.organizerSignUpManager.pageNumber)/7)")
                }
            }
            Spacer()
            Text("Social Media").font(.largeTitle).padding(.bottom, 15)
            Text("If you want to direct activists to your outside sources of information, please provide that information below.").font(.caption).foregroundColor(.black).padding(.horizontal, 15).padding(.bottom, 15)
            Group {
                Text("Twitter")
                TextField("Organization Twitter Link", text: self.$organizerSignUpManager.orgTwitter).textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 30)
                    .padding(.bottom, 5)
                Text("Facebook")
                TextField("Organization Facebook Link", text: self.$organizerSignUpManager.orgFacebook).textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 30)
                    .padding(.bottom, 5)
                Text("Youtube")
                TextField("Organization Youtube Link", text: self.$organizerSignUpManager.orgYoutube).textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 30)
                    .padding(.bottom, 5)
                Text("Instagram")
                TextField("Organization Instagram Link", text: self.$organizerSignUpManager.orgInsta).textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 30)
                    .padding(.bottom, 5)
            }
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
