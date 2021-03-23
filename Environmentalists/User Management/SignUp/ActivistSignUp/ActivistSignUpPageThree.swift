//
//  ActivistSignUpPageThree.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/29/21.
//

import SwiftUI

struct ActivistSignUpPageThree: View {
    
    @ObservedObject var activistSignUpManager: ActivistSignUpManager
    @State private var alert = false
    
    var body: some View {
        VStack (alignment: .center, spacing: 30){
            ProgressView(value: CGFloat(self.activistSignUpManager.pageNumber), total: 6) {
                HStack(alignment: .center) {
                    Text("Progress: (\(self.activistSignUpManager.pageNumber)/6)")
                }.padding(.top, 85)

            }
            Spacer()
            VStack (alignment: .center, spacing: 30) {
                Text("Your Name")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                Text("Please enter your first and last name below. Can be your real name or a nick name!").font(.caption).foregroundColor(.black).padding(.horizontal, 15)
                HStack(spacing: UIScreen.main.bounds.width / 10) {
                    TextField("First Name", text: self.$activistSignUpManager.firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.trailing, -10)
                        .padding(.leading, 10)

                    TextField("Last Name", text: self.$activistSignUpManager.lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, -10)
                        .padding(.trailing, 10)
                    
                }
                HStack {
                    Button("← Back", action: {
                        self.activistSignUpManager.pageNumber -= 1
                    }).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.05 ).background(Color.fireOrange).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
                    
                    Button("Next →", action: {
                        if !self.activistSignUpManager.firstName.isEmpty && !self.activistSignUpManager.lastName.isEmpty {
                            self.activistSignUpManager.pageNumber += 1
                        }
                        else {
                            self.alert.toggle()
                        }
                    }).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.05 ).background(Color.earthGreen).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
                }
            }.padding(.top, -60)
            Spacer()
        }.alert(isPresented: self.$alert) {
            Alert(title: Text(""), message: Text("Please fill in both fields"), dismissButton: .default(Text("OK")))
        }.padding(.horizontal, UIScreen.main.bounds.width/20)
    }
}

