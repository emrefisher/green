//
//  Terms and Conditions.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/27/20.
//

import SwiftUI

struct TermsAndConditions: View {
    var body: some View {
        Link(destination: URL(string: "https://firebasestorage.googleapis.com/v0/b/environmentalists-c25cd.appspot.com/o/TermsConditionsNew_App_11.27.pdf?alt=media&token=b96a61b4-7acb-44cf-b76b-f0ba7266e379")!) {
            Text("Terms and Conditions")
        }
    }
}

struct TermsAndConditions_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditions()
    }
}
