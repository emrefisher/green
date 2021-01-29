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
            DatePicker("Date of Birth", selection: self.$activistSignUpManager.dateOfBirth, in: ...minAgeBirthday, displayedComponents: .date)
            Picker(selection: self.$genderSelectionIndex, label: Text("Choose a Gender")) {
                ForEach(0..<genderArray.count) {
                    Text(genderArray[$0])
                }
            }
            HStack {
                Button("Back", action: {
                    self.activistSignUpManager.pageNumber -= 1
                })
                
                Button("Next", action: {
                    self.activistSignUpManager.pageNumber += 1
                })
            }
        }
    }
}


