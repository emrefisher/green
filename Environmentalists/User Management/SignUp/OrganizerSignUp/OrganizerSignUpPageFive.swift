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
        
        VStack (spacing: 30) {
            ProgressView(value: CGFloat(self.organizerSignUpManager.pageNumber), total: 6) {
                HStack(alignment: .center) {
                    Text("Progress: (\(self.organizerSignUpManager.pageNumber)/6)")
                }
            }
            Spacer()
            Text("Choose Profile Picture").font(.largeTitle)
            Text("This is what other users or organizations will see when they view your profile.").font(.caption).padding(.horizontal, 15)
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
                Button("← Back", action: {
                    self.organizerSignUpManager.pageNumber -= 1
                }).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.05 ).background(Color.fireOrange).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
                
                Button("Next →", action: {
                    self.organizerSignUpManager.pageNumber += 1
                }).foregroundColor(.white).frame(width: UIScreen.main.bounds.size.width*0.35, height: UIScreen.main.bounds.size.height*0.05 ).background(Color.earthGreen).clipShape(Capsule()).shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
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
        .padding(.horizontal, UIScreen.main.bounds.width/20).padding(.vertical, UIScreen.main.bounds.height/10)
        
    }
    
    private func loadImage() {
        guard let inputImage = self.organizerSignUpManager.pickedProfileImage else {return}
        self.organizerSignUpManager.profilePic = inputImage
    }
}


