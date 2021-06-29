//
//  ShoppingList.swift
//  CookMe
//
//  Created by Liliya Ivanova on 05.06.2021.
//

import SwiftUI

// Shopping list tab to keep track of needed ingredients
struct ShoppingList: View {
    
    @State private var showAddShoppingListItemSheet = false
    var fetchRequest: FetchRequest<ShoppingListItem>
    // Fetched shopping list items
    var shoppingListItems: [ShoppingListModel] { groupingShopingListByRecipe() }
    var items: FetchedResults<ShoppingListItem>{fetchRequest.wrappedValue}
    
    
    init() {
        // Retrieves shopping list from database
        self.fetchRequest = FetchRequest(entity: ShoppingListItem.entity(),
                                         sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingListItem.name, ascending: true)])
        
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if shoppingListItems.count > 0 {
                    List{
                        ForEach(shoppingListItems) { item in
                            Section(header: Text(item.recipe ?? "")) {
                                ForEach(Array(item.ingredients),id: \.self) { ingredient in
                                    Text(ingredient)
                                }
                                .onDelete  { row in
                                    removeItem(shoppingListItem: item, ingredientIndex: row)
                                }
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                } else {
                    EmptyViewShoppingList()
                }
            }
            
            .navigationTitle("Einkaufsliste")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        showAddShoppingListItemSheet.toggle()
                                    }, label: {
                                        Image(systemName: "plus")
                                    })
            )
        }
        .sheet(isPresented: $showAddShoppingListItemSheet, content: {
            IngredientCreation()
        })
    }
    
    // Groups shopping list items by recipe
    func groupingShopingListByRecipe() -> [ShoppingListModel] {
        var shoppingList: [ShoppingListModel] = []
        for item in items {
            if let shoppingListItem = shoppingList.first(where: {$0.recipe == item.recipe}) {
                shoppingListItem.ingredients.append(item.name ?? "")
            } else {
                let newItem = ShoppingListModel(recipe: item.recipe , ingredients: [item.name ?? ""])
                shoppingList.append(newItem)
            }
        }
        
        return shoppingList.sorted(by: {$0.recipe ?? "" < $1.recipe ?? ""})
    }
    
    // Deletes selected item from shopping list
    func removeItem(shoppingListItem: ShoppingListModel, ingredientIndex: IndexSet) {
        for index in ingredientIndex {
            let ingredient = shoppingListItem.ingredients[index]
            guard let item = items.first(where: {$0.name == ingredient && $0.recipe == shoppingListItem.recipe}) else { return }
            PersistenceController.shared.delete(item)
        }
    }
}

// Info text if shopping list is empty
struct EmptyViewShoppingList: View {
    
    var body: some View {
        VStack{
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .padding(50)
            Text("Alles erledigt")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .multilineTextAlignment(.center)
            Text("Es steht nichts mehr auf deiner Einkaufsliste")
                .multilineTextAlignment(.center)
                .padding()
        }
        .foregroundColor(.secondary)
    }
    
}

struct ShoppingList_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingList()
    }
}

