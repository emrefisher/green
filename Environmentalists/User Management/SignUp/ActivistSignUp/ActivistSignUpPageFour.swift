//
//  ActivistSignUpPageFour.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/29/21.
//

import SwiftUI

struct ActivistSignUpPageFour: View {
    
    @ObservedObject var activistSignUpManager: ActivistSignUpManager
    var genderArray = ["Male", "Female", "Other", "Prefer not to say"]
    @State private var genderSelectionIndex = 0
    let minAgeBirthday = Calendar.current.date(byAdding: .year, value: -16, to: Date())!
    
    var body: some View {
        VStack {
            
            Button("Back", action: {
                self.activistSignUpManager.pageNumber -= 1
            }).padding(.trailing, 330.0)
            
            
            Text("Personal Information")
                .font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 10.0)

            
            DatePicker("Date of Birth", selection: self.$activistSignUpManager.dateOfBirth, in: ...minAgeBirthday, displayedComponents: .date)
            Picker(selection: self.$genderSelectionIndex, label: Text("Choose a Gender")) {
                ForEach(0..<genderArray.count) {
                    Text(genderArray[$0])
                }
            }
            HStack {
                
                Button("Next", action: {
                    self.activistSignUpManager.pageNumber += 1
                }).frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height / 20).background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))).clipShape(Capsule()).padding(.vertical, 7.5)
                
                
            }
            Spacer()
        }
    }
}


