//
//  Settings.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/27/20.
//

import SwiftUI
import StoreKit

struct Settings: View {
    
    @State private var confirmSignOut = false
    @State private var ratingApp = false
    @EnvironmentObject var sessionManager: UserSessionManager
    @EnvironmentObject var currentUser: CurrentUser
    
    var body: some View {
            
        NavigationView{
            
            List{
                
//                link(icon: "leaf", label: "My Account", destination: MyAccount().environmentObject(currentUser))
                Button(action: {
                    self.ratingApp.toggle()
                    if let scene = UIApplication.shared.connectedScenes.first(where: {$0.activationState == .foregroundActive}) as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: scene)
                    }
                }) {
                    HStack {
                        Image(systemName: "leaf")
                        Text("Rate This App")
                        Spacer()
                    }
                }
                link(icon: "leaf", label: "About Us", destination: AboutUs())
//                link(icon: "leaf", label: "Notifications", destination: Notifications())
                Link(destination: URL(string: "https://firebasestorage.googleapis.com/v0/b/environmentalists-c25cd.appspot.com/o/Privacy_App_11.26.pdf?alt=media&token=f501812b-545e-4667-a954-3dd6919206b4")!) {
                    HStack {
                        Image(systemName: "leaf")
                        Text("Privacy Policy")
                        Spacer()
                    }
                }
                Link(destination: URL(string: "https://firebasestorage.googleapis.com/v0/b/environmentalists-c25cd.appspot.com/o/TermsConditionsNew_App_11.27.pdf?alt=media&token=b96a61b4-7acb-44cf-b76b-f0ba7266e379")!) {
                    HStack {
                        Image(systemName: "leaf")
                        Text("Terms and Conditions")
                        Spacer()
                    }
                }

                    Button(action: {
                        self.confirmSignOut.toggle()
                    }) {
                        HStack {
                            Image(systemName: "leaf")
                            Text("Sign Out")
                            Spacer()
                        }
                    }

            }.navigationTitle("Settings")
            
        }.alert(isPresented: self.$confirmSignOut) {
            Alert(title: Text("Confirm Sign Out"), message: Text("Are you sure you want to sign out?"), primaryButton: .default(Text("Yes"), action: {
                sessionManager.signOut()
            }), secondaryButton: .default(Text("No")))
        }
        
    }
    
    private func link<Destination: View>(icon: String, label: String, destination: Destination) -> some View {
        return NavigationLink(destination: destination) {
            HStack {
                Image(systemName: icon)
                Text(label)
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
