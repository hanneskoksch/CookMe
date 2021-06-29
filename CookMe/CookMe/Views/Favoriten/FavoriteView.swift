//
//  FavoriteView.swift
//  CookMe
//
//  Created by Liliya Ivanova on 04.06.2021.
//

import SwiftUI

// Displays recipes marked as favorites
struct FavoriteView: View {
    
    var fetchRequest: FetchRequest<Recipe>
    var items: FetchedResults<Recipe>{fetchRequest.wrappedValue}
    
    init() {
        // Fetching favorite recipes from database
        self.fetchRequest = FetchRequest(entity: Recipe.entity(),
                                         sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.name, ascending: true)], predicate: NSPredicate(format: "isFavorite == true"))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if items.count > 0 {
                    MainViewFavorites(items: self.items)
                } else {
                    EmptyViewFavorites()
                }
            }
            .navigationTitle("Favoriten")
        }
    }
}



struct MainViewFavorites: View {
    
    var items: FetchedResults<Recipe>
    
    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                NavigationLink (destination:
                                    RecipeView(recipe: item)
                ){
                    RecipeCard(item: item)
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
    
}

// Info text if no recipes are marked as favorites
struct EmptyViewFavorites: View {
    
    var body: some View {
        VStack{
            Image(systemName: "star")
                .font(.system(size: 60))
                .padding(50)
            Text("Noch keine Rezepte als Favorit markiert")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .multilineTextAlignment(.center)
            Text("Markiere Rezepte als Favorit, damit sie hier gesammelt angezeigt werden")
                .multilineTextAlignment(.center)
                .padding()
        }
        .foregroundColor(.secondary)
    }
    
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
