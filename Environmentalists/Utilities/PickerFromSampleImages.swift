//
//  PickerFromSampleImages.swift
//  Environmentalists
//
//  Created by Ian Campbell on 4/3/21.
//

import SwiftUI
import Photos

struct PickerFromSampleImages: View {
    
    @State private var samplePictures = ["deathValley", "gatesArctic", "olympic", "redwood", "yosemite", "zion"]
    @ObservedObject var eventCreationManager: EventCreationManager
    @Binding var showSamplesPicker: Bool
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    var body: some View {
        VStack {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(samplePictures, id: \.self) { pic in
                    Button(action: {
                        eventCreationManager.eventPic = Image(pic)
                    }) {
                        Image(pic)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width / 2.25)
                            .cornerRadius(10)
                            .clipped()
                            .padding(.horizontal)
                    }
                }
            }
        }
            Button(action: {
                showSamplesPicker.toggle()
            }) {
                Text("Confirm")
            }
        }
    }
}
