//
//  PrivacyPolicy.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/27/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct PrivacyPolicy: View {
    var body: some View {
        Link(destination: URL(string: "https://firebasestorage.googleapis.com/v0/b/environmentalists-c25cd.appspot.com/o/Privacy_App_11.26.pdf?alt=media&token=f501812b-545e-4667-a954-3dd6919206b4")!) {
            Text("Privacy Policy")
        }
    }
}

struct PrivacyPolicy_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicy()
    }
}
