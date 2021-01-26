//
//  OrganizerSignUpPageSix.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/26/21.
//

import SwiftUI

struct OrganizerSignUpPageSix: View {
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
            Text("Choose Cover Photo").font(.largeTitle)
            if self.organizerSignUpManager.coverPhoto != nil {
                self.organizerSignUpManager.coverPhoto!
                    .resizable()
                    .clipShape(Rectangle())
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/5, alignment: .center)
                    .onTapGesture {
                        self.showActionSheet.toggle()
                    }
            }
            else {
                Image(systemName: "camera.on.rectangle")
                    .resizable()
                    .clipShape(Rectangle())
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/5, alignment: .center)
                    .onTapGesture {
                        self.showActionSheet.toggle()
                    }
            }
            HStack {
                Button("Back", action: {
                    self.organizerSignUpManager.pageNumber -= 1
                })
                Button("Prepare to Submit", action: {
                    self.organizerSignUpManager.pageNumber += 1
                })
            }
            Spacer()
        }.sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
            ImagePicker(pickedImage: self.$organizerSignUpManager.pickedCoverPhoto, showImagePicker: self.$showImagePicker, imageData: self.$organizerSignUpManager.coverPhotoData, sourceType: self.$sourceType)
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
        guard let inputImage = self.organizerSignUpManager.pickedCoverPhoto else {return}
        self.organizerSignUpManager.coverPhoto = inputImage
    }
}

