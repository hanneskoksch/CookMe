//
//  RecipeView.swift
//  CookMe
//
//  Created by Hannes Koksch on 12.05.21.
//

import SwiftUI

// Detail view of a recipe
struct RecipeView: View {
    
    var fetchRequest: FetchRequest<ShoppingListItem>
    // Fetched shopping list items
    var shoppingListItems: FetchedResults<ShoppingListItem>{fetchRequest.wrappedValue}
    var recipe: Recipe
    
    @State private var selectedTab = 0
    @State private var favorite: Bool
    @State private var showEditView = false
    
    
    init(recipe: Recipe) {
        
        _favorite = State(initialValue: recipe.isFavorite)
        self.recipe = recipe
        self.fetchRequest = FetchRequest(entity: ShoppingListItem.entity(),
                                         sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingListItem.name, ascending: true)])
        print(shoppingListItems.count)
        
        //this changes the "thumb" of picker that selects between items
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemPink
        //these lines change the text color for various states
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
    }
    
    
    var body: some View {
        ScrollView(.vertical){
            VStack {
                recipe.image?.getImage()
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .clipped()
                
                VStack(alignment: .leading){
                    HStack {
                        Text(recipe.name!)
                            .font(.title)
                        Button(action: {
                            favorite.toggle()
                            recipe.isFavorite.toggle()
                            PersistenceController.shared.save()
                        }){
                            Image(systemName: favorite ? "star.fill" : "star")
                                .foregroundColor(favorite ? Color.yellow : Color.gray)
                        }
                        Spacer()
                    }
                    Text(recipe.recipeDescription!)
                        .font(.subheadline)
                }
                .padding()
                
                // Picker for ingredients and instructions views
                Picker(selection: $selectedTab, label: Text("Rezept")) {
                    Text("Zutaten").tag(0)
                    Text("Zubereitung").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                
                if selectedTab == 0 {
                    // MARK: - Tab Zutaten
                    
                    Text("Für \(recipe.persons) Personen")
                        .bold()
                        .padding()
                    if recipe.ingredients == "" {
                        Text("Fügen Sie Zutaten für das Rezept hinzu")
                    } else {
                        VStack{
                        ForEach(recipe.ingredients!.components(separatedBy: ">>"), id: \.self) { item in
                            IngredientListItem(shoppingListItem: getShoppingListItem(item: item, recipe: recipe.name), recipe: recipe.name, item: item)
                                .padding(10)
                        }
                        }
                    }
                } else {
                    // MARK: - Tab Zubereitung
                    
                    Text("Dauer der Zubereitung: \(recipe.instructionTime) Min")
                        .bold()
                        .padding()
                    if recipe.instructions == "" {
                        Text("Fügen Sie die Anleitung für das Rezept hinzu")
                    } else {
                        ForEach(0..<recipe.instructions!.components(separatedBy: ">>").count, id: \.self) { index in
                            HStack{
                                Text("\(index + 1). " + (recipe.instructions?.components(separatedBy: ">>")[index])!)
                                    .frame(maxWidth: .infinity, alignment:.leading)
                                    .padding(10)
                            }
                        }
                        
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            showEditView.toggle()
        }, label: {
            Text("Bearbeiten")
        }))
        .sheet(isPresented: $showEditView, content: {
            RecipeEditor(recipe: recipe)
        })
    }
    
    // Returns selected shopping list item
    func getShoppingListItem(item: String, recipe: String?) -> ShoppingListItem? {
        let shoppingListItem = shoppingListItems.first(where: {$0.name == item && $0.recipe == recipe})
        return shoppingListItem
    }
}

let dummyRecipeCoreData = Recipe() // For testing preview

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipe: dummyRecipeCoreData)
    }
}

