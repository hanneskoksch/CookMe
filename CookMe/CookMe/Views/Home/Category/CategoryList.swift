//
//  CategoryList.swift
//  CookMe
//
//  Created by Torben Ziegler on 11.05.21.
//

import SwiftUI
import CoreData

// Lists recipes of a selected category
struct CategoryList: View {
    
    var category: Category
    var fetchRequest: FetchRequest<Recipe>
    // Fetched recipes of selected category
    var items: FetchedResults<Recipe>{fetchRequest.wrappedValue}
    
    @State private var showFavoritesOnly = false
    
    // Computed property for toggling favorites
    var filteredItems: [Recipe] {
        items.filter{ item in
            (!showFavoritesOnly || item.isFavorite)
        }
    }
    
    init(category: Category) {
        self.category = category
        // Retrieves recipes of the selected category
        self.fetchRequest = FetchRequest(entity: Recipe.entity(),
                                         sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.name, ascending: true)], predicate: NSPredicate(format: "category == %@", category))
    }
    
    @State private var showingSheet = false
    
    var body: some View {
        
        VStack {
            if items.count > 0 {
                List {
                    Toggle(isOn: $showFavoritesOnly){
                        Text("Nur Favoriten anzeigen")
                    }
                    ForEach(filteredItems, id: \.self) { item in
                        NavigationLink (destination:
                                            RecipeView(recipe: item)
                        ){
                            RecipeCard(item: item)
                        }
                    }
                    .onDelete(perform: removeItem)
                }
                .listStyle(GroupedListStyle())
                
            } else {
                EmptyCategoryView() // Shows info text if no recipes are yet created
            }
        }
        .navigationTitle(category.name ?? "Unbekannte Kategorie")
        .navigationBarItems(trailing: Button(action: {
            showingSheet.toggle()
        }, label: {
            Image(systemName: "plus")
        }))
        .sheet(isPresented: $showingSheet) {
            RecipeCreation(category: category)
        }
        
    }
    
    func removeItem(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            PersistenceController.shared.delete(item)
        }
    }
    
}

// Info text view if category has no recipes created yet
struct EmptyCategoryView: View {
    
    var body: some View {
        VStack{
            Image(systemName: "folder.fill.badge.plus")
                .font(.system(size: 60))
                .padding(50)
            Text("Noch keine Rezepte erstellt")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .multilineTextAlignment(.center)
            Text("Erstelle jetzt dein erstes Rezept")
                .multilineTextAlignment(.center)
                .padding()
        }
        .foregroundColor(.secondary)
    }
}

struct CategoryList_Previews: PreviewProvider {
    static var previews: some View {
        CategoryList(category: Category())
    }
}

