//
//  ActivistSignUpPageFour.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/29/21.
//

import SwiftUI

struct ActivistSignUpPageFour: View {
    
    @ObservedObject var activistSignUpManager: ActivistSignUpManager
    var genderArray = ["Male", "Female", "Other", "None"]
    @State private var genderSelectionIndex = 0
    let minAgeBirthday = Calendar.current.date(byAdding: .year, value: -16, to: Date())!
    
    var body: some View {
        VStack (alignment: .center, spacing: 30) {
            ProgressView(value: CGFloat(self.activistSignUpManager.pageNumber), total: 6) {
                HStack(alignment: .center) {
                    Text("Progress: (\(self.activistSignUpManager.pageNumber)/6)")
                }.padding(.top, 85)

            }
            Spacer()
            Text("Age & Gender")
                .font(.largeTitle)
                .foregroundColor(.black)
            Text("Please indicate your date of birth and preferred gender identity below.").font(.caption).foregroundColor(.black).padding(.horizontal, 15)
            HStack (spacing: 17) {
                Text("Date of Birth")
                DatePicker("", selection: self.$activistSignUpManager.dateOfBirth, in: ...minAgeBirthday, displayedComponents: .date).labelsHidden()
            }
            HStack {
                Text("Preferred Gender").padding(.trailing, 10).padding(.top, -40)
                Picker(selection: self.$genderSelectionIndex, label: Text("Preferred Gender").foregroundColor(.black)) {
                    ForEach(0..<genderArray.count) {
                        Text(genderArray[$0])
                    }
                }.pickerStyle(WheelPickerStyle()).scaleEffect(x: 1, y: 1).labelsHidden().padding(.top, -60).frame(width: UIScreen.main.bounds.width/4).clipped().padding(.leading, -5)
                .contentShape(Rectangle())
            }
            HStack {
                Button("← Back", action: {
                    self.activistSignUpManager.pageNumber -= 1
                }).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.05 ).background(Color.fireOrange).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
                
                Button("Next →", action: {
                    self.activistSignUpManager.pageNumber += 1
                }).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.05 ).background(Color.earthGreen).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
            }.padding(.top, -30)
            Spacer()
        }.padding(.horizontal, UIScreen.main.bounds.width/20)
    }
}


