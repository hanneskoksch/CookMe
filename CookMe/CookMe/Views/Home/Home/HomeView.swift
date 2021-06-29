//
//  HomeView.swift
//  CookMe
//
//  Created by Torben Ziegler on 11.05.21.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    // Fetching categories from database
    @FetchRequest(entity: Category.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
    )
    // Fetched category objects
    var categories: FetchedResults<Category>
    
    @State private var activeSheet: ActiveSheet?
    @State private var categoryToEdit: Category?
    
    
    var body: some View {
        
        NavigationView {
            VStack {
                // Toggling between views
                if categories.count > 0 {
                    // Shows categories, if any exist
                    MainView(categories: self.categories, categoryToEdit: $categoryToEdit, activeSheet: $activeSheet)
                } else {
                    // Shows info text, if no categories are created
                    EmptyView()
                }
            }
            .navigationTitle("Kategorien")
            .navigationBarItems(trailing: Button(action: {
                activeSheet = .first
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(item: $activeSheet) { item in
                switch item {
                case .first:
                    // Calls sheet for creating a category
                    CategoryCreation()
                case .second:
                    // Calls sheet to edit existing category
                    CategoryEditor(categoryToEdit: $categoryToEdit)
                }
            }
        }
        
    }
    
}

enum ActiveSheet: Identifiable {
    case first, second
    
    var id: Int {
        hashValue
    }
}

struct MainView: View {
    
    var categories: FetchedResults<Category>
    @Binding var categoryToEdit: Category?
    @Binding var activeSheet: ActiveSheet?
    
    var body: some View {
        List {
            ForEach(categories) { category in
                // Accessing recipes from their category
                NavigationLink (destination: CategoryList(category: category)){
                    CategoryCard(category: category)
                }
                .contextMenu(ContextMenu(menuItems: {
                    Button(action: {
                        categoryToEdit = category
                        activeSheet = .second
                    }, label: {
                        Label("Bearbeiten", systemImage: "pencil.circle")
                    })
                    Button(action: {
                        PersistenceController.shared.delete(category)
                    }, label: {
                        Label("Löschen", systemImage: "minus.circle")
                    })
                }))
            }
            .onDelete(perform: removeItem)
        }
        .listStyle(GroupedListStyle())
    }
    
    // Deletes selected category from database
    func removeItem(at offsets: IndexSet) {
        for index in offsets {
            let item = categories[index]
            PersistenceController.shared.delete(item)
        }
    }
}

// Info text when no categories are created
struct EmptyView: View {
    
    var body: some View {
        VStack{
            Image(systemName: "folder.fill.badge.plus")
                .font(.system(size: 60))
                .padding(50)
            Text("Noch keine Kategorien erstellt")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .multilineTextAlignment(.center)
            Text("Erstelle jetzt deine erste Kategorie")
                .multilineTextAlignment(.center)
                .padding()
        }
        .foregroundColor(.secondary)
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
