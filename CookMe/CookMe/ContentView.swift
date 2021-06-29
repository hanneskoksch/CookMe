//
//  ContentView.swift
//  CookMe
//
//  Created by Torben Ziegler on 11.05.21.
//

import SwiftUI
import CoreData

// Entry point of the application
struct ContentView: View {
 
    var body: some View {
        // Creating Tab Bar with Home, Favorites and ShoppingList Tabs
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            FavoriteView()
                .tabItem {
                    Image(systemName: "star")
                    Text("Favoriten")
                }
            ShoppingList()
                .tabItem {
                    Image(systemName: "text.badge.plus")
                    Text("Einkaufsliste")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
