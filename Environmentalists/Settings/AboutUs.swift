//
//  AboutUs.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/27/20.
//  Edited by Will Kraft on 1/24/20
//

import SwiftUI
import MessageUI

struct ColorManager {
    // create static variables for custom colors
    static let earthGreen = Color("Earth Green")
    static let fireOrange = Color("Fire Orange")
    //... add the rest of your colors here
}

// Or you can use an extension
// this will allow you to just type .spotifyGreen and you wont have to use ColorManager.spotifyGreen
extension Color {
    static let earthGreen = Color("Earth Green")
    static let fireOrange = Color("Fire Orange")
    static let waterBlue = Color("Water Blue")
    static let dirtBrown = Color("Dirt Brown")
    static let dearthGreen = Color("Dark Earth Green")
    // ... add the rest of your colors here
}

struct AboutUs: View {
    
    /// The delegate required by `MFMailComposeViewController`
    private let mailComposeDelegate = MailDelegate()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack() {
                    Text("About Us").font(.largeTitle)
                        .frame(width: UIScreen.main.bounds.size.width)
                        .foregroundColor(.black)
                        .padding(.top, 20)
                        .padding(.bottom, 0)
                    Image("team_placeholder").resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.size.width / 1.8, height: UIScreen.main.bounds.size.width / 1.8)
                        .cornerRadius(120)
                        .padding(.bottom, 20)
                    Divider().background(Color.black)
                        .frame(width: UIScreen.main.bounds.width / 2)
                    Group {
                        Text("Our Mission").font(.title)
                            .padding(.top, 15)
                        Text("Environmend was built with one goal in mind — to promote environmental activism. Scientists predict that global climate change will cause irreversible damage to our planet within the next 10 years and we hope with this app we can contribute to the cultural shift and sentiment about how we take care of the Earth. Thank you for downloading!")
                            .padding(.horizontal, 50)
                            .padding(.top, 10)
                            .padding(.bottom, 20)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)

                    }
                    Divider().background(Color.black)
                        .frame(width: UIScreen.main.bounds.width / 2)
                    Group {
                        Text("Contact Us").font(.title)
                            .padding(.top, 20)
                        VStack {
                            Text("Got a question or some feedback for us? Send us a message.").font(.caption)
                            .padding(.horizontal, 50)
                            .padding(.top, 5)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                            //.multilineTextAlignment(.left)
                            .fixedSize(horizontal: false, vertical: true)
                            Button(action: {
                                self.presentMailCompose()
                            }) {
                                Image(systemName: "message.fill")
                            }.padding(10)
                            .font(.system(size: 16))
                            .background(Color.black)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .cornerRadius(40)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.black, lineWidth: 1.5)
                                )
                        }
                    }
                    
                }.frame(width: UIScreen.main.bounds.size.width)
            }
            .navigationBarTitle("", displayMode: .inline)
            /*.background(Image("team_placeholder")
                            .resizable()
                            .overlay(TintOverlay().opacity(0.75))
                            .blur(radius: 3))
            */
            .foregroundColor(.black)
        }
    }
}

// MARK: The mail part
extension AboutUs {

    /// Delegate for view controller as `MFMailComposeViewControllerDelegate`
    private class MailDelegate: NSObject, MFMailComposeViewControllerDelegate {

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            controller.dismiss(animated: true)
        }

    }

    /// Present an mail compose view controller modally in UIKit environment
    private func presentMailCompose() {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let vc = UIApplication.shared.keyWindow?.rootViewController

        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = mailComposeDelegate


        vc?.present(composeVC, animated: true)
    }
}

struct AboutUs_Previews: PreviewProvider {
    static var previews: some View {
        AboutUs()
    }
}
