//
//  MapView.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/5/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct MapView: View {
    
    @Binding var showMapView: Bool
    
    var body: some View {
        WebImage(url: URL(string: "https://images.pexels.com/photos/1067333/pexels-photo-1067333.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"))
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(showMapView: .constant(true))
    }
}
