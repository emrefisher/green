//
//  SearchBar.swift
//  Environmentalists
//
//  Created by Ian Campbell on 1/3/21.
//

import SwiftUI
import FirebaseFirestore

struct SearchBar: View {
    
    @Binding var text: String
    @State var isSearching = false
    @Binding var searchData: [Event]
    
    var body: some View {
        
        VStack {
            HStack {
                TextField("Search...", text: $text)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                            if isSearching {
                                Button(action: {
                                    self.text = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        self.isSearching = true
                    }
                
                if self.isSearching {
                    Button(action: {
                        self.isSearching = false
                        self.text = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                    }) {
                        Text("Cancel")
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
            }
            
            if self.text != ""{

                if  self.searchData.filter({$0.eventTitle.lowercased().contains(self.text.lowercased())}).count == 0 {

                    Text("No Results Found").foregroundColor(Color.black.opacity(0.5)).padding()
                }

                else{

                    List(self.searchData.filter{$0.eventTitle.lowercased().contains(self.text.lowercased())}) {i in

                            NavigationLink(i.eventTitle, destination: EventPage(event: i))
                        

                    }.frame(height: UIScreen.main.bounds.height / 5)
                }

            }
        }
    }
}
