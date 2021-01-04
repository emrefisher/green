//
//  SearchDirectoryTopBar.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/3/21.
//

import SwiftUI

struct FindEventsViewTopBar: View {
    
    @State var searchText = ""
    @Binding var showMapView: Bool
    
    @State var showFilters = false
    @State var distance: Double = 1
    @State var eventType: [String] = [String]()
    @State var interest: [String] = [String]()
    @ObservedObject var eventManager: EventManager
    @ObservedObject var searchBarInfo = SearchBarInformation()
    
    var body: some View {
        
        ZStack() {
            SearchBar(text: self.$searchText, searchData: self.$eventManager.eventInformation)
            
//            HStack(spacing: 20) {
//                Picker(selection: $showMapView, label: Text(""), content: {
//                    Text("List View").tag(false)
//                    Text("Map View").tag(true)
//                }).pickerStyle(SegmentedPickerStyle())
//                .padding(.leading, 50)
//
//                Button(action: {
//                    self.showFilters.toggle()
//                }) {
//                    Image(systemName: "line.horizontal.3")
//                }.font(.system(size: 22.5))
//                .padding(.trailing, 25)
//                .sheet(isPresented: $showFilters) {
//                    FilterPage(distance: self.$distance)
//                }
//
//            }.padding(.top, 30)
            
        }.padding(.bottom, 15)
    }
}


struct FilterPage: View {
    
    @Binding var distance: Double
    
    var body: some View {
        
        VStack {
            Text("Distance")
            Text("(Within \(self.distance, specifier: "%.0f") miles)")
            Slider(value: $distance, in: 1...100, step: 1).padding(.horizontal, 25)
        }
    }
}
