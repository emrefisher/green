//
//  OrganizerSignUpPageFive.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/25/21.
//

import SwiftUI

struct OrganizerSignUpPageFive: View {
    @ObservedObject var organizerSignUpManager: OrganizerSignUpManager
    @State private var showImagePicker = false
    @State private var showActionSheet = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        
        VStack {
            ProgressView(value: CGFloat(self.organizerSignUpManager.pageNumber), total: 6) {
                HStack(alignment: .center) {
                    Text("Progress: (\(self.organizerSignUpManager.pageNumber)/6)")
                }
            }
            Spacer()
            Text("Choose Profile Pic").font(.largeTitle)
            if self.organizerSignUpManager.profilePic != nil {
                self.organizerSignUpManager.profilePic!
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 200, height: 200, alignment: .center)
                    .onTapGesture {
                        self.showActionSheet.toggle()
                    }
            }
            else {
                Image(systemName: "person.fill")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 200, height: 200, alignment: .center)
                    .onTapGesture {
                        self.showActionSheet.toggle()
                    }
            }
            HStack {
                Button("Back", action: {
                    self.organizerSignUpManager.pageNumber -= 1
                })
                Button("Next", action: {
                    self.organizerSignUpManager.pageNumber += 1
                })
            }
            Spacer()
        }.sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
            ImagePicker(pickedImage: self.$organizerSignUpManager.pickedProfileImage, showImagePicker: self.$showImagePicker, imageData: self.$organizerSignUpManager.profilePicData, sourceType: self.$sourceType)
        }.actionSheet(isPresented: self.$showActionSheet) {
            ActionSheet(title: Text(""), buttons: [
                            .default(Text("Choose a Photo")) {
                                self.sourceType = .photoLibrary
                                self.showImagePicker = true
                            },
                            .default(Text("Take a Photo")) {
                                self.sourceType = .camera
                                self.showImagePicker = true
                            },
                .cancel()
            ])
        }
        .padding(.horizontal, UIScreen.main.bounds.width/20)
        
    }
    
    private func loadImage() {
        guard let inputImage = self.organizerSignUpManager.pickedProfileImage else {return}
        self.organizerSignUpManager.profilePic = inputImage
    }
}


