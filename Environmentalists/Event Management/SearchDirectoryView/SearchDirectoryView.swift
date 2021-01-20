//
//  SearchDirectoryView.swift
//  Environmentalists
//
//  Created by Ian Campbell on 9/5/20.
//

import SwiftUI
import FirebaseFirestore
import MapKit
import SDWebImageSwiftUI

struct SearchDirectoryView: View {

    @ObservedObject var eventManager = EventManager()
    @State var filteredItems = [Event]()
    @State var hasSetFilteredItems = true

    var body: some View {

        ZStack {

            SearchDirectoryViewPage(filteredItems: self.$filteredItems, eventManager: self.eventManager)

        }.onAppear {
            eventManager.clearEvents()
            eventManager.getEventInformation()
            self.filteredItems = eventManager.eventInformation
        }

    }
}
struct SearchDirectoryViewPage: View {

    @Binding var filteredItems: [Event]
    @ObservedObject var eventManager: EventManager

    var body: some View {

        if self.filteredItems.count == 0 {
            self.filteredItems = eventManager.eventInformation
        }
        
        return VStack {

            CustomNavigationView(view: AnyView(Home(filteredItems: $filteredItems)), largeTitle: true, title: "Search Events",

                                 onSearch: { (txt) in

                                    // filterting Data...
                                    if txt != ""{
                                        self.filteredItems = eventManager.eventInformation.filter{$0.eventTitle.lowercased().contains(txt.lowercased())}
                                    }
                                    else{
                                        self.filteredItems = eventManager.eventInformation
                                    }

                                 },

                                 onCancel: {
                                    // Do Your Own Code When Search And Canceled....
                                    self.filteredItems = eventManager.eventInformation

                                 })
                .ignoresSafeArea()

        }.onAppear(perform: {self.filteredItems = eventManager.eventInformation})

    }
}

struct SearchDirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Home

struct Home: View {
    // for search Bar...
    @Binding var filteredItems : [Event]

    var body: some View {

        //        NavigationView{
        //                    VStack(spacing: 0) {

        //                        FindEventsViewTopBar(eventManager: self.eventManager)
        //
        //                List(eventManager.eventInformation) {Event in
        //                    NavigationLink(destination: EventPage(event: Event)) {
        //                        EventRow(event: Event)
        //                    }
        //                }
        List(filteredItems) {Event in
            ZStack {
                
                EventRow(event: Event)

                NavigationLink(destination: EventPage(event: Event)) {
                    EmptyView()
                }.frame(width: 0)
                .opacity(0)
            }
        }
        //                        }
        //
        //
        //                    }
        //        // Apps List View...
        //
        //        ScrollView(.vertical, showsIndicators: false) {
        //
        //            VStack(spacing: 15){
        //
        //                // Apps List...
        //                ForEach(filteredItems){item in
        //
        //                    // Card View....
        //                    NavigationLink(
        //                        destination: PageView(item: item),
        //                        label: {
        //                            CardView(item: item)
        //                        })
        //                }
        //            }
        //            .padding()
        //        }
    }
}

struct CustomNavigationView: UIViewControllerRepresentable {


    func makeCoordinator() -> Coordinator {
        return CustomNavigationView.Coordinator(parent: self)
    }

    // Just Change Your View That Requires Search Bar...
    var view: AnyView

    // Ease Of Use.....

    var largeTitle: Bool
    var title: String
    var placeHolder: String

    // onSearch And OnCancel Closures....
    var onSearch: (String)->()
    var onCancel: ()->()

    // requre closure on Call...

    init(view: AnyView,placeHolder: String? = "Search", largeTitle: Bool? = true, title: String, onSearch: @escaping (String)->(),onCancel: @escaping ()->()) {

        self.title = title
        self.largeTitle = largeTitle!
        self.placeHolder = placeHolder!
        self.view = view
        self.onSearch = onSearch
        self.onCancel = onCancel
    }

    // Integrating UIKit Navigation Controller With SwiftUI View...
    func makeUIViewController(context: Context) -> UINavigationController {

        // requires SwiftUI View...
        let childView = UIHostingController(rootView: view)

        let controller = UINavigationController(rootViewController: childView)

        // Nav Bar Data...

        controller.navigationBar.topItem?.title = title
        controller.navigationBar.prefersLargeTitles = largeTitle

        // search Bar....

        let searchController = UISearchController()
        searchController.searchBar.placeholder = placeHolder

        // setting delegate...
        searchController.searchBar.delegate = context.coordinator

        // setting Search Bar In NavBar...
        // disabling hide on scroll...

        // disabling dim bg..
        searchController.obscuresBackgroundDuringPresentation = false

        controller.navigationBar.topItem?.hidesSearchBarWhenScrolling = false
        controller.navigationBar.topItem?.searchController = searchController

        return controller
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {

        // Updating Real Time...
        uiViewController.navigationBar.topItem?.title = title
        uiViewController.navigationBar.topItem?.searchController?.searchBar.placeholder = placeHolder
        uiViewController.navigationBar.prefersLargeTitles = largeTitle
    }

    // search Bar Delegate...

    class Coordinator: NSObject,UISearchBarDelegate{

        var parent: CustomNavigationView

        init(parent: CustomNavigationView) {
            self.parent = parent
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            // when text changes....
            self.parent.onSearch(searchText)
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            // when cancel button is clicked...
            self.parent.onCancel()
        }
    }
}
//
//
// struct SearchDirectoryView: View {
//
//    @EnvironmentObject var sessionManager: UserSessionManager
//    @EnvironmentObject var currentUser: CurrentUser
//    @State var showMapView = false
//
//    var body: some View {
//        ZStack {
//            VStack {
//                if showMapView {
//                    MapView(showMapView: self.$showMapView)
//                }
//                else {
//                    EventListView(showMapView: self.$showMapView)
//                        .environmentObject(sessionManager)
//                }
//            }
//        }
//    }
//}


struct EventRow: View {
    
    @State var event: Event
    
    var body: some View {
        
        VStack(alignment: .center) {
                WebImage(url: URL(string: self.event.eventPhotoURL))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width*0.91, height: UIScreen.main.bounds.height/4, alignment: .center)
                    .clipped()
                    .cornerRadius(10)
            
            VStack(alignment: .leading) {
                    
                    Text(self.event.eventTitle)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)

                HStack{
                    
                    Image(systemName: "calendar.badge.clock")
                    
                    Text("\(self.event.date), \(self.event.time)")
                        .font(.subheadline)
                        

                }
                
                HStack{
                    
                    Image(systemName: "mappin.and.ellipse")
                    
                    Text(self.event.location)
                        .font(.subheadline)
                        .fontWeight(.light)
                        
                    
                }
                HStack{
                    
                    Image(systemName: "person.fill")
                    
                    Text(self.event.eventOrganizer)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                    
                }
                Spacer()
                
                
            }
            .frame(width: UIScreen.main.bounds.width*0.91)
        }
    }
}

//struct EventListView: View {
//
//    @EnvironmentObject var sessionManager: UserSessionManager
//
//    @Binding var showMapView: Bool
//
//    @ObservedObject var eventManager = EventManager()
//
//    var body: some View {
//
//        NavigationView{
//            VStack(spacing: 0) {
//
//                FindEventsViewTopBar(showMapView: $showMapView, eventManager: self.eventManager)
//
////                List(eventManager.eventInformation) {Event in
////                    NavigationLink(destination: EventPage(event: Event)) {
////                        EventRow(event: Event)
////                    }
////                }
//                List {
//                    ForEach(eventManager.eventInformation) { Event in
//                        NavigationLink(destination: EventPage(event: Event)) {
//                            EventRow(event: Event)
//                        }
//                    }
//                }
//
//
//            }
//            .navigationBarTitle("", displayMode: .inline)
//            .navigationBarItems(trailing:
//                                    Button(action: {
//                                        self.eventManager.clearEvents()
//                                        self.eventManager.getEventInformation()
//                                    }) {
//                                        Image(systemName: "arrow.clockwise")
//                                    })
//
//        }
//    }
//
//}
//
//struct SearchDirectoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchDirectoryView()
//    }
//}
//
